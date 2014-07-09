require 'ostruct'

module WWTD
  class UserAction < Command
    def run(player, input)
      # Set available directions to move
      directions = ['north', 'south', 'east', 'west', 'n', 's', 'e', 'w']
      items = ["phone", "dresser", 'jacket', 'socks', 'underwear', 'shower', 'toothbrush', 'toothpaste', 'tv', 'backpack']
      # Sanitize input
      input.downcase!
      input = input.squeeze(" ")

      # Get Player's current room and quest
      current_room = WWTD.db.get_room(player.room_id)

      if input.include?('fight') || input.include?('kill')
        update_last_completed_action(player, current_room, 'fight')
        result = WWTD::Fight.run(player, current_room)
        if result.success?
          return success :message => result.message, :player => player
        else
          return success :message => result.error, :player => player
        end
      end

      if current_room.name == "Player's Living Room"
        qp_data = WWTD.db.get_quest_progress(player.id, 1).data
        # binding.pry
        if qp_data["entered_living_room"] && !qp_data["killed_first_zombie"]
          new_player = WWTD.db.update_player(player.id, dead: true)
          puts "GAME OVER".white.on_red
          return success :message => "You don't fight a zombie, you don't live. Better luck in the next life.", :player => new_player
        end
      end
      # may not need this
      # current_quest = WWTD.db.get_quest_progress(player.id, current_room.quest_id)

      # Show location before splitting input into array
      if input.include?('where am i')
        return success :message => "You are currently in: " + current_room.name, :player => player
      end

      input = input.split(' ')
      attempt_move = directions & input
      use_item = items & input

      # Check if player is attempting to move
      if attempt_move.length > 0
        result = WWTD::EnterRoom.run(attempt_move.first, player)
        update_last_completed_action(player, current_room, "changed rooms")
        if result.success?
          return result
        else
          return success :message => result.error, :player => player
        end
      # Check if player is attempting to use an item
      elsif use_item.length > 0
        update_last_completed_action(player, current_room, "use #{use_item[0]}")
        result = WWTD::UseItem.run(player, use_item.first, input)
        if result.success?
          return success :message => result.message, :player => player
        else
          return success :message => result.error, :player => player
        end
      # Shows room description
      elsif input.include?('look') && !input.include?('at')
        update_last_completed_action(player, current_room, 'checked description')
        player_room = WWTD.db.get_player_room(player.id, current_room.id)
        return success :message => player_room.description, :player => player
      # Shows items player has
      elsif input.include?('inventory')
        update_last_completed_action(player, current_room, 'inventory')
        result = WWTD::ShowInventory.run(player)
        if result.success?
          return success :message => result.message, :player => result.player
        else
          return success :message => result.error, :player => result.player
        end
      else
        return success :message => "I'm sorry, what was that? I don't know that command.", :player => player
      end
    end

    def update_last_completed_action(player, room, action)
      if room.name == "Player's Living Room"
        WWTD.db.change_qp_data(player.id, room.quest_id, last_completed_action: action)
      else
        WWTD.db.change_qp_data(player.id, room.quest_id, last_lr_action: action)
      end
     end
  end
end
