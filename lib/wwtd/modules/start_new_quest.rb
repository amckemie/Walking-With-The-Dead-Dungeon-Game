require 'colorize'

module WWTD
  module StartNewQuest
    def start_new_quest?(room, player)
      quest_progress = WWTD.db.get_quest_progress(player.id, room.quest_id)
      quest = WWTD.db.get_quest(room.quest_id)
      if room.start_new_quest && !quest_progress
        puts "Congratulations! You've made it to the start of a new quest.".white.on_light_blue
        WWTD.db.create_quest_progress(quest_id: quest.id, player_id: player.id, furthest_room_id: room.id, data: quest.data, complete: false)
        insert_player_quest_characters(player.id, quest.id)
        insert_player_room_items(player.id, quest.id)
        insert_player_rooms(player.id, quest.id)
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

    def insert_player_rooms(player_id, quest_id)
      rooms = WWTD.db.get_all_quest_rooms(quest_id)
      rooms.each do |room|
      WWTD.db.create_player_room(player_id: player_id,
                                quest_id: quest_id,
                                room_id: room.id,
                                canN: room.canN,
                                canE: room.canE,
                                canS: room.canS,
                                canW: room.canW,
                                start_new_quest: room.start_new_quest,
                                description: room.description
                                )
      end
    end
  end
end
