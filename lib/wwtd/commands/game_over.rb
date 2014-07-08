require 'ostruct'

module WWTD
  class GameOver < Command
    def run(player)
      all_qp = WWTD.db.get_player_quests(player.id)

      all_qp.each {|quest_progress| WWTD.db.delete_quest_progress(quest_progress.id)}
    end

# WWTD::StartNewQuest.start_new_quest?(first_room, new_player)
    # # Putting the cell phone in their inventory (first item)
    # first_item = WWTD.db.get_first_item
    # WWTD::AddToInventory.run(new_player, first_item)
  end
end
