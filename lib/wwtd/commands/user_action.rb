require 'ostruct'

module WWTD
  class UserAction < Command
    include ManipulateQuestProgress

    def run(player, input)
      # Set available directions to move
      directions = ['north', 'south', 'east', 'west', 'n', 's', 'e', 'w']
      items = ["phone", "dresser", "drawer", "money", 'jacket', 'socks', 'underwear', 'shower', 'toothbrush', 'toothpaste', 'tv', 'backpack', 'pictures']
      # Sanitize input
      input.downcase!
      input = input.squeeze(" ")

      # Get Player's current room and quest
      current_room = WWTD.db.get_room(player.room_id)

      # enter first completed action

      if input.include?('fight') || input.include?('kill')
        update_quest_data(player, current_room, 'fight')
        result = WWTD::Fight.run(player, current_room)
        if result.success?
          return success :message => result.message
        else
          return success :message => result.error
        end
      end

      if current_room.name == "Player's Living Room"
        qp_data = WWTD.db.get_quest_progress(player.id, 1).data
        if qp_data["entered_living_room"] && !qp_data["killed_first_zombie"]
          WWTD.db.update_player(player.id, dead: true)
          puts "GAME OVER".white.on_red
          return success :message => "You don't fight a zombie, you don't live. Better luck in the next life."
        end
      end
      # may not need this
      # current_quest = WWTD.db.get_quest_progress(player.id, current_room.quest_id)

      # Show location before splitting input into array
      if input.include?('where am i')
        return success :message => "You are currently in: " + current_room.name
      end

      input = input.split(' ')
      attempt_move = directions & input
      use_item = items & input

      # Check if player is attempting to move
      if attempt_move.length > 0
        result = WWTD::EnterRoom.run(attempt_move.first, player)
        update_quest_data(player, current_room, "changed rooms")
        if result.success?
          return result
        else
          return success :message => result.error
        end
      # Check if player is attempting to use an item
      elsif use_item.length > 0
        result = WWTD::UseItem.run(player, use_item.first, input)
        update_quest_data(player, current_room, "use #{use_item[0]}")
        if result.success?
          return success :message => result.message
        else
          return success :message => result.error
        end
      # Shows room description
      elsif input.include?('look') && !input.include?('at')
        update_quest_data(player, current_room, 'checked description')
        player_room = WWTD.db.get_player_room(player.id, current_room.id)
        return success :message => player_room.description
      elsif input.include?('sleep') || input.include?('snooze')
        return success :message => "Nappy nap nap"
      # Shows items player has
      elsif input.include?('inventory') || input.include?('inv')
        update_quest_data(player, current_room, 'inventory')
        result = WWTD::ShowInventory.run(player)
        if result.success?
          return success :message => result.message
        else
          return success :message => result.error
        end
      else
        return success :message => "Sorry, I don't know that command."
      end
    end
  end
end
