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
        WWTD.db.update_quest_progress(player.id, new_room.quest_id, furthest_room_id: new_room.id)
        # is_new_quest = start_new_quest?(new_room, player)
        return success :message => new_room.description, :player => new_player, :room => new_room
      else
        return failure("Silly you. There is nothing there; You can't go that way", {player: player})
      end

      # if dir == 'north' || dir == 'n'

      #   if room.north && room.canN
      #     new_room = WWTD.db.get_room(room.north)
      #     new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
      #     is_new_quest = start_new_quest?(new_room, player)
      #     return success :player => new_player, :room => new_room, :start_new_quest? => is_new_quest
      #   elsif !room.north
      #     return failure("Silly you. There is nothing there; You can't go that way")
      #   else
      #     return failure("Sorry, that direction is not currently accessible.")
      #   end
      # elsif dir == 'south' || dir == 's'
      #   if room.south && room.canS
      #     new_room = WWTD.db.get_room(room.south)
      #     new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
      #     is_new_quest = start_new_quest?(new_room, player)
      #     return success :player => new_player, :room => new_room, :start_new_quest? => is_new_quest
      #   elsif !room.south
      #     return failure("Silly you. There is nothing there; You can't go that way")
      #   else
      #     return failure("Sorry, that direction is not currently accessible.")
      #   end
      # elsif dir == 'east' || dir == 'e'
      #   if room.east && room.canE
      #     new_room = WWTD.db.get_room(room.east)
      #     new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
      #     is_new_quest = start_new_quest?(new_room, player)
      #     return success :player => new_player, :room => new_room, :start_new_quest? => is_new_quest
      #   elsif !room.east
      #     return failure("Silly you. There is nothing there; You can't go that way")
      #   else
      #     return failure("Sorry, that direction is not currently accessible.")
      #   end
      # elsif dir == 'west' || dir == 'w'
      #   if room.west && room.canW
      #     new_room = WWTD.db.get_room(room.west)
      #     new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
      #     is_new_quest = start_new_quest?(new_room, player)
      #     return success :player => new_player, :room => new_room, :start_new_quest? => is_new_quest
      #   elsif !room.west
      #     return failure("Silly you. There is nothing there; You can't go that way")
      #   else
      #     return failure("Sorry, that direction is not currently accessible.")
      #   end

    end
  end
end
