module WWTD
  class ActiveRecordDatabase
    def create_room_item(attrs)
      RoomItem.create!(attrs)
    end

    def get_player_room_items(player_id, room_id)
      result = []
      items = RoomItem.where('player_id = ? AND room_id = ?', player_id, room_id)
      items.each do |item|
        item = Item.find(item.item_id)
        result << build_item(item)
      end
      result
    end

    def delete_player_room_item(player_id, room_id, item_id)
      items = RoomItem.where('player_id = ? AND room_id = ? AND item_id = ?', player_id, room_id, item_id)
      items.each do |item|
        item.destroy
      end
    end
  end
end
