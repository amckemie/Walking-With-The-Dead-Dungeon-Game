require 'ostruct'

module WWTD
  class UserAction < Command
    def run(player, input)
      # Set available directions to move
      directions = ['north', 'south', 'east', 'west', 'n', 's', 'e', 'w']
      # Sanitize input
      input.downcase!
      input.squeeze(" ")

      # Get Player's current room and quest
      current_room = WWTD.db.get_room(player.room_id)
      current_quest = WWTD.db.get_quest_progress(player.id, current_room.quest_id)

      # Show location before splitting input into array
      if input.include?('where am i')
        return success :message => "You are currently in: " + current_room.name, :player => player
      end

      input = input.split(' ')
      attempt_move = directions & input

      # Check if player is attempting to move
      if attempt_move.length > 0
        result = WWTD::EnterRoom.run(attempt_move.first, player)
      # Shows room description
      elsif input.include?('look')
        return success :message => current_room.description, :player => player
      # Shows items player has
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
