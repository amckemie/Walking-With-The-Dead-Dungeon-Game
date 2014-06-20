module WWTD
  class ActiveRecordDatabase
    def create_room_item(attrs)
      RoomItem.create!(attrs)
    end

    def create_item_objects(room_item_arr)
      result = []
      room_item_arr.each do |item|
        item = Item.find(item.item_id)
        result << build_item(item)
      end
      result
    end

    def get_player_room_items(player_id, room_id)
      items = RoomItem.where('player_id = ? AND room_id = ?', player_id, room_id)
      create_item_objects(items)
    end

    def get_quest_items_left(player_id, quest_id)
      items = RoomItem.where('player_id = ? AND quest_id = ?', player_id, quest_id)
      create_item_objects(items)
    end

    def delete_player_room_item(player_id, room_id, item_id)
      item = RoomItem.where('player_id = ? AND room_id = ? AND item_id = ?', player_id, room_id, item_id).first
      # binding.pry
      item.destroy
    end

    def delete_player_room_items
    end
  end
end
