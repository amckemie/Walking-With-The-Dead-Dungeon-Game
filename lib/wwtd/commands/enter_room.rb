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
        quest = WWTD.db.get_quest(room.quest_id)
        p "Congratulations! You've made it to the start of a new quest."
        WWTD.db.create_quest_progress(quest_id: quest.id, player_id: player.id, room_id: room.id, data: quest.data, complete: false)
        insert_player_quest_characters(player.id, quest.id)
        insert_player_room_items(player.id, quest.id)
        # WWTD.create_inventory()
        return true
      else
        return false
      end
    end

    def insert_player_quest_characters(player_id, quest_id)
      chars = WWTD.db.get_all_quest_characters(quest_id)
      chars.each do |char|
        WWTD.db.create_quest_character(quest_id: quest_id, room_id: char.room_id, player_id: player_id, character_id: char.id)
      end
    end

    def insert_player_room_items(player_id, quest_id)
      items = WWTD.db.get_items_for_quest(quest_id)
      items.each do |item|
        WWTD.db.create_room_item(quest_id: quest_id, player_id: player_id, room_id: item.room_id, item_id: item.id)
      end
    end
  end
end
