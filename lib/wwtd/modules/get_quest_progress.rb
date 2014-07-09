module WWTD
  module GetQuestProgress
    def get_data(player_id, quest_id)
      WWTD.db.get_quest_progress(player_id, quest_id).data
    end
  end
end
