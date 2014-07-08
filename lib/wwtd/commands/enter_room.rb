require 'ostruct'

module WWTD
  class EnterRoom < Command

    def run(dir, player)
      room = WWTD.db.get_room(player.room_id)
      direction = case dir
      when 'north', 'n' then 'north'
      when 'south', 's' then 'south'
      when 'east', 'e' then 'east'
      when 'west', 'w' then 'west'
      end

      connection = room.has_connection?(direction)
      new_room = WWTD.db.get_room(room.send(direction)) if connection

      if connection && new_room.name == "Player's Living Room"
        first_action = WWTD.db.get_quest_progress(player.id, new_room.quest_id).data["first_completed_action"]
        if first_action != 'answer phone'
          puts "OH NO! You thought the cure worked.".white.on_light_blue
          puts "But nope. It didn't, and zombies are back. And one just crashed through the window, killing you.".white.on_light_blue
          return failure("GAME OVER")
        else
          new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
          update_furthest_room(new_player, new_room)
          zombie = WWTD.db.get_character_by_name("First Zombie")
          return success :message => zombie.description, :player => new_player
        end
      end

      if connection
        new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
        update_furthest_room(new_player, new_room)
        # is_new_quest = start_new_quest?(new_room, player)
        return success :message => new_room.name, :player => new_player
      else
        return failure("Silly you. There is nothing there; You can't go that way", {player: player})
      end
    end

    def update_furthest_room(player, room)
      qp = WWTD.db.get_quest_progress(player.id, room.quest_id)
      if qp.furthest_room_id < room.id
        WWTD.db.update_quest_progress(player.id, room.quest_id, furthest_room_id: room.id)
      end
    end
  end
end
