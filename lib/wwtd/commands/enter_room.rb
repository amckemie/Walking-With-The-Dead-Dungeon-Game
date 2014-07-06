require 'ostruct'

module WWTD
  class EnterRoom < Command
    # include WWTD::StartNewQuest

    def run(dir, player)

      direction = case dir
      when 'north', 'n' then 'north'
      when 'south', 's' then 'south'
      when 'east', 'e' then 'east'
      when 'west', 'w' then 'west'
      end

      if dir == 'start'
        new_room = WWTD.db.get_first_room
        new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
        first_item = WWTD.db.get_first_item
        is_new_quest = start_new_quest?(new_room, player)
        WWTD::AddToInventory.run(new_player, first_item)
        return success :player => new_player, :room => new_room, :start_new_quest? => is_new_quest
      elsif room.has_connection?(direction)
        # room.send('north')
        # room.north
        new_room = WWTD.db.get_room(room.send(direction))
        new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
        is_new_quest = start_new_quest?(new_room, player)
        return success :player => new_player, :room => new_room, :start_new_quest? => is_new_quest
      else
        return failure("Silly you. There is nothing there; You can't go that way")
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
