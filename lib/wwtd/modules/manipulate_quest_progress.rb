module WWTD
  module ManipulateQuestProgress
    def get_quest_data(player_id, quest_id)
      WWTD.db.get_quest_progress(player_id, quest_id).data
    end

    def update_quest_data(player, room, action)
      # update first_complete_action once
      quest_data = get_quest_data(player.id, room.quest_id)
      WWTD.db.change_qp_data(player.id, room.quest_id, first_completed_action: action) if !quest_data['first_completed_action']

      if room.name == "Player's Living Room"
        WWTD.db.change_qp_data(player.id, room.quest_id, last_lr_action: action)
      else
        WWTD.db.change_qp_data(player.id, room.quest_id, last_completed_action: action)
      end
    end
  end
end
