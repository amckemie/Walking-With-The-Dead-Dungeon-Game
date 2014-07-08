require 'json'

module WWTD
  class ActiveRecordDatabase
    def build_quest_progress(quest_progress)
      WWTD::QuestProgress.new(quest_progress)
    end

    # May want to convert data back to hash when building QP object
    def create_quest_progress(attrs)
      data = attrs[:data].to_json
      attrs[:data] = data
      ar_quest_progress = QuestProgress.create!(attrs)
      build_quest_progress(ar_quest_progress)
    end

    def get_quest_progress(player_id, quest_id)
      ar_quest_progress = QuestProgress.where('player_id = ? AND quest_id = ?', player_id, quest_id).first
      return nil if ar_quest_progress.nil?
      ar_quest_progress.data = parse_data_attribute(ar_quest_progress)
      build_quest_progress(ar_quest_progress)
    end

    def get_player_quests(player_id)
      quests = QuestProgress.where('player_id = ? ', player_id)
      return nil if quests.length == 0
      quests.map {|quest|
        quest.data = parse_data_attribute(quest)
        build_quest_progress(quest)
      }
    end

    def get_latest_quest(player_id)
      latest_quest = QuestProgress.where('player_id = ? ', player_id).order(:quest_id).last
      latest_quest.data = parse_data_attribute(latest_quest)
      build_quest_progress(latest_quest)
    end

    def parse_data_attribute(quest_progress)
      JSON.parse(quest_progress.data)
    end

    def delete_quest_progress(quest_progress_id)
      ar_quest_progress = QuestProgress.find(quest_progress_id)
      ar_quest_progress.destroy
    end

    def update_quest_progress(player_id, quest_id, input)
      ar_quest_progress = QuestProgress.where('player_id = ? AND quest_id = ?', player_id, quest_id).first
      ar_quest_progress.update(input)
      build_quest_progress(ar_quest_progress)
    end

    def change_qp_data(player_id, quest_id, input)
      ar_quest_progress = get_quest_progress(player_id, quest_id)
      input.each do |key, value|
        ar_quest_progress.data[key] = value
      end
      new_data = ar_quest_progress.data.to_json
      updated_progress = QuestProgress.where('player_id = ? AND quest_id = ?', player_id, quest_id).first
      updated_progress.update(data: new_data)
    end
  end
end
