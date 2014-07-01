require 'ostruct'

module WWTD
  class EnterRoom < Command
    def run(dir, player)
      dir.downcase!
      room = WWTD.db.get_room(player.room_id)
      if dir == 'north' || dir == 'n'
        if room.north && room.canN
          new_room = WWTD.db.get_room(room.north)
          new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
          return success :player => new_player
        elsif !room.north
          return failure("Silly you. There is nothing there; You can't go that way")
        else
          return failure("Sorry, that direction is not currently accessible.")
        end
      elsif dir == 'south' || dir == 's'
        if room.south && room.canS
          new_room = WWTD.db.get_room(room.south)
          new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
          return success :player => new_player
        elsif !room.south
          return failure("Silly you. There is nothing there; You can't go that way")
        else
          return failure("Sorry, that direction is not currently accessible.")
        end
      elsif dir == 'east' || dir == 'e'
        if room.east && room.canE
          new_room = WWTD.db.get_room(room.east)
          new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
          return success :player => new_player
        elsif !room.east
          return failure("Silly you. There is nothing there; You can't go that way")
        else
          return failure("Sorry, that direction is not currently accessible.")
        end
      elsif dir == 'west' || dir == 'w'
        if room.west && room.canW
          new_room = WWTD.db.get_room(room.west)
          new_player = WWTD.db.update_player(player.id, room_id: new_room.id)
          return success :player => new_player
        elsif !room.west
          return failure("Silly you. There is nothing there; You can't go that way")
        else
          return failure("Sorry, that direction is not currently accessible.")
        end
      else
        return failure("Sorry, that is not a known direction. Which way do you want to go?")
      end

      # if room.start_new_quest
      #   qp = WWTD.db.create_quest_progress(quest_id: room.quest_id, player_id: player_id, room_id: room.id)
      #   return success :start_new_quest? => true, :quest_progress => qp
      # else
      #   return success :start_new_quest? => false, :quest_progress => false
      # end
    end
  end
end
