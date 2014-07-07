require 'ostruct'

module WWTD
  class UseItem < Command
    def run(player, item_name, input)
      new_input = prepare_input(item_name, input)
      result = check_item_actions(item_name, new_input)

      if result.success? && result.action == 'take'
        result = take_item(item_name, player)
        if result.success?
          return success :message => result.message
        else
          return success :message => result.error
        end
      end

      case item_name
      when 'phone'
      when 'dresser'
      when 'jacket'
        if result.success?
          return success :message => 'You are now nice and toasty with the jacket on.'
        else
          return success :message => result.error
        end
      when 'socks'
        # if result.success?
        #   return success :message => 'You are now nice and toasty with the jacket on.'
        # else
        #   return success :message => result.error
        # end
      when 'underwear'
      when 'shower'
      when 'toothbrush'
      when 'toothpaste'
      when 'tv'
      else
        # must be backpack
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
      input.delete('in')
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
        return failure('Sorry, that item cannot do that.')
      end
    end

    def take_item(item, player)
      backpack_id = WWTD.db.get_item_by_name('backpack').id
      inventory = WWTD.db.get_player_inventory(player.id)
      has_backpack = false
      inventory.each do |item|
        has_backpack = true if item.id == backpack_id
      end
      # binding.pry

      if has_backpack
        return success :message => "Item taken."
      else
        return failure("Sorry, you have nothing to take this item in yet.")
      end
    end

    def pick_up_item(item)
    end
  end
end
