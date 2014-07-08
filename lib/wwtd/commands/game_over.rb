require 'ostruct'

module WWTD
  class GameOver < Command
    def run(player, quest_id)
      all_qp = WWTD.db.get_player_quests(player.id)
      all_rooms = WWTD.db.get_all_player_rooms(player.id)

      all_qp.each {|quest_progress| WWTD.db.delete_quest_progress(quest_progress.id)}
      all_rooms.each {|player_room| WWTD.db.delete_player_room(player_room.id)}
      WWTD.db.delete_all_quest_characters(player.id, quest_id)
      WWTD.db.delete_inventory_from_quest(player.id, quest_id)
    end

# WWTD::StartNewQuest.start_new_quest?(first_room, new_player)
    # # Putting the cell phone in their inventory (first item)
    # first_item = WWTD.db.get_first_item
    # WWTD::AddToInventory.run(new_player, first_item)
  end
end
