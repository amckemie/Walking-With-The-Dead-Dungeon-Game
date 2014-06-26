module WWTD
  class ActiveRecordDatabase
    # (This table tracks all the items that are contained within a quest and the specific room it is in)
    def create_quest_item(attrs)
      QuestItem.create!(attrs)
    end

    def get_quests_for_item(item_id)
      ar_item = Item.find(item_id)
      ar_quests = ar_item.quests.distinct
      ar_quests.map {|quest| build_quest(quest) }
    end

    def get_items_for_quest(quest_id)
      ar_quest = Quest.find(quest_id)
      items = ar_quest.items
      items.map {|item| build_item(item) }
    end

    def get_items_for_room(room_id)
      ar_room = Room.find(room_id)
      items = ar_room.items
      items.map {|item| build_item(item) }
    end

    # may need to change this to quest and item id
    def delete_quest_item(qi_id)
      ar_quest_item = QuestItem.find(qi_id)
      ar_quest_item.destroy
      return true if !QuestItem.exists?(qi_id)
    end
  end
end
