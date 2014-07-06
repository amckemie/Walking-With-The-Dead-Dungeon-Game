module WWTD
  class UserAction < Command
    def run(player, input)
      if input.include?('where am i')

      elsif input.include?('look')
      elsif input.include?('inventory')
        result = WWTD::ShowInventory(player)
        return result.message
      else
        puts "Other"
      end
    end
  end
end
