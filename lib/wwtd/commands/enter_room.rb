require 'ostruct'

module WWTD
  class EnterRoom < Command
    def run(dir, player)
      dir.downcase!
      room = WWTD.db.get_room(player.room_id)
      if dir == 'north' || dir == 'n'
        if room.north && room.canN

          return success
        elsif !room.north
          return failure("Silly you. There is nothing there; You can't go that way")
        else
          return failure("Sorry, that direction is not currently accessible.")
        end
      elsif dir == 'south' || dir == 's'
        if room.south && room.canS
          return true
        elsif !room.south
          return failure("Silly you. There is nothing there; You can't go that way")
        else
          return failure("Sorry, that direction is not currently accessible.")
        end
      elsif dir == 'east' || dir == 'e'
        if room.east && room.canE
          return true
        elsif !room.east
          return failure("Silly you. There is nothing there; You can't go that way")
        else
          return failure("Sorry, that direction is not currently accessible.")
        end
      elsif dir == 'west' || dir == 'w'
        if room.west && room.canW
          return true
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