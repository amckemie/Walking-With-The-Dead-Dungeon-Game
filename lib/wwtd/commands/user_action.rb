require 'ostruct'

module WWTD
  class UserAction < Command
    def run(player, input)
      if input.include?('where am i')
        room = WWTD.db.get_room(player.room_id)
        return success :message => "You are currently in: " + room.name, :player => player
      elsif input.include?('look')
      elsif input.include?('inventory')
        result = WWTD::ShowInventory.run(player)
        if result.success?
          return success :message => result.message, :player => result.player
        else
          return success :message => result.error, :player => result.player
        end
      else
        return success :message => "unknown command.", :player => player
      end
    end
  end
end
