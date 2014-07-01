require 'ostruct'

module WWTD
  class EnterRoom < Command
    def run(dir, player)
      dir.downcase!

      if dir != 'start'
        room = WWTD.db.get_room(player.room_id)
      end

      if dir == 'north' || dir == 'n'
        if room.north && room.canN
          new_room = WWTD.db.get_room(room.north)
          new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
          is_new_quest = start_new_quest?(new_room, player)
          return success :player => new_player, :room => new_room, :start_new_quest? => is_new_quest
        elsif !room.north
          return failure("Silly you. There is nothing there; You can't go that way")
        else
          return failure("Sorry, that direction is not currently accessible.")
        end
      elsif dir == 'south' || dir == 's'
        if room.south && room.canS
          new_room = WWTD.db.get_room(room.south)
          new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
          is_new_quest = start_new_quest?(new_room, player)
          return success :player => new_player, :room => new_room, :start_new_quest? => is_new_quest
        elsif !room.south
          return failure("Silly you. There is nothing there; You can't go that way")
        else
          return failure("Sorry, that direction is not currently accessible.")
        end
      elsif dir == 'east' || dir == 'e'
        if room.east && room.canE
          new_room = WWTD.db.get_room(room.east)
          new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
          is_new_quest = start_new_quest?(new_room, player)
          return success :player => new_player, :room => new_room, :start_new_quest? => is_new_quest
        elsif !room.east
          return failure("Silly you. There is nothing there; You can't go that way")
        else
          return failure("Sorry, that direction is not currently accessible.")
        end
      elsif dir == 'west' || dir == 'w'
        if room.west && room.canW
          new_room = WWTD.db.get_room(room.west)
          new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
          is_new_quest = start_new_quest?(new_room, player)
          return success :player => new_player, :room => new_room, :start_new_quest? => is_new_quest
        elsif !room.west
          return failure("Silly you. There is nothing there; You can't go that way")
        else
          return failure("Sorry, that direction is not currently accessible.")
        end
      elsif dir == 'start'
        new_room = WWTD.db.get_first_room
        new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
        is_new_quest = start_new_quest?(new_room, player)
        return success :player => new_player, :room => new_room, :start_new_quest? => is_new_quest
      else
        return failure("Sorry, that is not a known direction. Which way do you want to go?")
      end

    end

    def start_new_quest?(room, player)
      if room.start_new_quest
        WWTD.db.create_quest_progress(quest_id: room.quest_id, player_id: player.id, room_id: room.id)
        return true
      else
        return false
      end
    end
  end
end
