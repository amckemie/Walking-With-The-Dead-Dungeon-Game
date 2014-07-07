require 'ostruct'

module WWTD
  class EnterRoom < Command
    # include WWTD::StartNewQuest

    def run(dir, player)
      room = WWTD.db.get_room(player.room_id)
      direction = case dir
      when 'north', 'n' then 'north'
      when 'south', 's' then 'south'
      when 'east', 'e' then 'east'
      when 'west', 'w' then 'west'
      end

      if room.has_connection?(direction)
        new_room = WWTD.db.get_room(room.send(direction))
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
