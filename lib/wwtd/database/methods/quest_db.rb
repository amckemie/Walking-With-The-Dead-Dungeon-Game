module WWTD
  class ActiveRecordDatabase
    def create_quest(attrs)
      ar_quest = Quest.create(attrs)
      build_quest(ar_quest)
    end

    def build_quest(quest)
      WWTD::Quest.new(id: quest.id, name: quest.name)
    end

    def update_quest(q_id, data)
      ar_quest = Quest.find(q_id)
      ar_quest.update(data)
      build_quest(ar_quest)
    end

    def get_quest(q_id)
      ar_quest = Quest.find(q_id)
      build_quest(ar_quest)
    end

    def delete_quest(q_id)
      ar_quest = Quest.find(q_id)
      ar_quest.destroy
      return true if !Quest.exists?(q_id)
    end
  end
end
