module WWTD
  class ActiveRecordDatabase
    def create_quest(attrs)
      data = attrs[:data].to_json
      attrs[:data] = data
      ar_quest = Quest.create(attrs)
      build_quest(ar_quest)
    end

    def build_quest(quest)
      WWTD::Quest.new(id: quest.id, name: quest.name, data: quest.data)
    end

    def update_quest(q_id, data)
      ar_quest = Quest.find(q_id)
      ar_quest.update(data)
      build_quest(ar_quest)
    end

    # Refactor to use find first then save on AR object? Do same for questProgress....
    def change_quest_data(quest_id, input)
      ar_quest = get_quest(quest_id)
      input.each do |key, value|
        ar_quest.data[key] = value
      end
      new_data = ar_quest.data.to_json
      updated_quest = Quest.find(quest_id)
      updated_quest.update(data: new_data)
    end

    def get_quest(q_id)
      ar_quest = Quest.find(q_id)
      ar_quest.data = parse_data_attribute(ar_quest)
      build_quest(ar_quest)
    end

    def delete_quest(q_id)
      ar_quest = Quest.find(q_id)
      ar_quest.destroy
      return true if !Quest.exists?(q_id)
    end

    def parse_data_attribute(quest)
      JSON.parse(quest.data)
    end
  end
end
