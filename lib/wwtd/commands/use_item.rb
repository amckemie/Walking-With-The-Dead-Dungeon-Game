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
