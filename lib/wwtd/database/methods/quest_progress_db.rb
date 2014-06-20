require 'json'

module WWTD
  class ActiveRecordDatabase
    def create_quest_progress(attrs)
      data = attrs[:data].to_json
      attrs[:data] = data
      QuestProgress.create!(attrs)
      WWTD::QuestProgress.new(attrs)
    end

    def get_quest_progress(player_id, quest_id)
      progress = QuestProgress.where('player_id = ? AND quest_id = ?', player_id, quest_id).first
      data = JSON.parse(progress.data)

    end
  end
end
