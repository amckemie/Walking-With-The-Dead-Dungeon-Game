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
      if connection
        new_room = WWTD.db.get_room(room.send(direction))
        new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
        update_furthest_room(new_player, new_room)
      else
        return failure("Silly you. There is nothing there; You can't go that way", {player: player})
      end

      if new_room.name == "Player's Living Room"
        result = WWTD::EnterLivingRoom.run(new_player, new_room)
        return result
      else
        # is_new_quest = start_new_quest?(new_room, player)
        return success :message => new_room.name, :player => new_player
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
