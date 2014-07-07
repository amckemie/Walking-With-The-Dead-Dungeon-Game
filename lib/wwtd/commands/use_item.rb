require 'ostruct'

module WWTD
  class UseItem < Command
    def run(player, item, input)
      case item
      when 'phone'
      when 'dresser'
      when 'jacket'
      when 'socks'
      when 'underwear'
      when 'shower'
      when 'toothbrush'
      when 'toothpaste'
      when 'tv'
      else
        # must be backpack
      end
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

        # binding.pry
      if actions.include?(input)
        return success :action => input
      else
        return failure('Sorry, that item cannot do that.')
      end
    end
        # return failure('You must be hallucinating from fear. That item is nowhere near.')
  end
end
