require 'ostruct'

module WWTD
  class GameOver < Command
    include StartNewQuest
    def run(player, quest_id)
      all_qp = WWTD.db.get_player_quests(player.id)
      all_rooms = WWTD.db.get_all_player_rooms(player.id)

      all_qp.each {|quest_progress| WWTD.db.delete_quest_progress(quest_progress.id)}
      all_rooms.each {|player_room| WWTD.db.delete_player_room(player_room.id)}
      WWTD.db.delete_all_quest_characters(player.id, quest_id)
      WWTD.db.delete_inventory_from_quest(player.id, quest_id)

      first_room = WWTD.db.get_first_room
      updated_player = WWTD.db.update_player(player.id, room_id: first_room.id, dead: false)
      start_player_over(first_room, updated_player)
      return success :message => "What would you like to do"
    end

    def start_player_over(room, player)
      start_new_quest?(room, player)
      first_item = WWTD.db.get_first_item
      WWTD::AddToInventory.run(player, first_item)
    end
  end
end
