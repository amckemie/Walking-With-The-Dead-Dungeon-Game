module WWTD
  class ActiveRecordDatabase
    # (This table tracks all the items that are contained within a quest and the specific room it is in)
    def create_quest_item(attrs)
      QuestItem.create!(attrs)
    end

    def get_quests_for_item(item_id)
      result = []
      ar_item = Item.find(item_id)
      quests = ar_item.quests.distinct
      quests.each do |quest|
        result << build_quest(quest)
      end
      result
    end

    def get_items_for_quest(quest_id)
      result = []
      ar_quest = Quest.find(quest_id)
      items = ar_quest.items
      items.each do |item|
        result << build_item(item)
      end
      result
    end

    def get_items_for_room(room_id)
      result = []
      ar_room = Room.find(room_id)
      items = ar_room.items
      items.each do |item|
        result << build_item(item)
      end
      result
    end

    def delete_quest_item(qi_id)
      ar_quest_item = QuestItem.find(qi_id)
      ar_quest_item.destroy
      return true if !QuestItem.exists?(qi_id)
    end
  end
end
