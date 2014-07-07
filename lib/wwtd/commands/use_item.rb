require 'ostruct'
require 'asciiart'

module WWTD
  class UseItem < Command
    def run(player, item_name, input)
      new_input = prepare_input(item_name, input)
      new_item = WWTD.db.get_item_by_name(item_name)
      if input.include?("look") || input.include?('examine')
        return success :message => new_item.description
      end

      result = check_item_actions(item_name, new_input)

      if result.success? && (result.action == 'take' || result.action == 'pick up') && item_name != 'shower'
        result = take_item(item_name, player)
        if result.success?
          WWTD::AddToInventory.run(player, new_item)
          return success :message => result.message
        else
          return success :message => result.error
        end
      end


      case item_name
      when 'phone'
        result = WWTD::UsePhone.run(player)
      when 'dresser'
      when 'jacket'
        if result.success?
          return success :message => 'You are now nice and toasty with the jacket on.'
        else
          return success :message => result.error
        end
      when 'socks'
        if result.success?
          return success :message => 'You are now wearing the socks, which is kinda gross, but what can you do?'
        else
          return success :message => result.error
        end
      when 'shower'
        if result.success?
          if result.action == 'clean'
            return success :message => "Well, that's one way to start your day. But the shower is now clean."
          else
          # update quest progress to include taken_shower
            return success :message => "You're so fresh and so clean clean now."
          end
        else
          return success :message => result.error
        end
      when 'tv'
        if result.success?
          ppgirls = AsciiArt.new("./lib/assets/ppgirls.jpeg")
          puts ppgirls.to_ascii_art
          return success :message => "You're going to watch the powder puff girls?? Really??"
        else
          return success :message => result.error
        end
      when 'backpack'
        if result.success?
          new_item = WWTD.db.get_item_by_name('backpack')
          result = WWTD::AddToInventory.run(player, new_item)
          message = result.message ||= "Good idea. You'll probably need this."
          return success :message => message
        else
          return success :message => result.error
        end
      end
    end

    def prepare_input(item, input)
      # Delete item, commonly used articles, and anything past 4 words from input
      input.slice!(4..-1)
      input.delete(item)
      input.delete('the')
      input.delete('a')
      input.delete('an')
      input.delete('with')
      input
    end
    # Prepare input before sending to this method using input.delete(item) and delete articles
    def check_item_actions(item_name, input)
      item = WWTD.db.get_item_by_name(item_name)
      actions = item.actions.split(', ')
      if input.length > 1
        input = input.join(' ')
      else
        input = input.first
      end

      if actions.include?(input)
        return success :action => input
      else
        return failure('Sorry, that is not a known action for that.')
      end
    end

    def take_item(item_name, player)
      backpack = WWTD.db.get_item_by_name('backpack')
      if item_name == "backpack"
        return success :message => "Good idea. You'll probably need this."
      end

      inventory = WWTD.db.get_player_inventory(player.id)
      has_backpack = false
      inventory.each do |item|
        has_backpack = true if item.id == backpack.id
      end


      if has_backpack
        return success :message => "Item picked up!"
      else
        return failure("Sorry, you have nothing to take this item in yet.")
      end
    end

    def pick_up_item(item)

    end
  end
end
