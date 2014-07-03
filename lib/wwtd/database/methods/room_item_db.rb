module WWTD
  class ActiveRecordDatabase
    def create_room_item(attrs)
      RoomItem.create!(attrs)
    end

    def create_item_objects(room_item_arr)
      room_item_arr.map {|item|
        item = Item.find(item.item_id)
        build_item(item)
      }
    end

    def get_player_room_items(player_id, room_id)
      items = RoomItem.where('player_id = ? AND room_id = ?', player_id, room_id)
      create_item_objects(items)
    end

    def get_quest_items_left(player_id, quest_id)
      items = RoomItem.where('player_id = ? AND quest_id = ?', player_id, quest_id)
      create_item_objects(items)
    end

    def get_all_player_items(player_id)
      items = RoomItem.where("player_id = ? ", player_id)
      create_item_objects(items)
    end

    def room_item_exists?(player_id, room_id, item_id)
      result = RoomItem.where('player_id = ? AND room_id = ? AND item_id = ?', player_id, room_id, item_id)
      result.length > 0 ? true : false
    end

    def delete_player_room_item(player_id, room_id, item_id)
      item = RoomItem.where('player_id = ? AND room_id = ? AND item_id = ?', player_id, room_id, item_id).first
      item.destroy
    end

    def delete_player_room_items(player_id, quest_id)
      items = RoomItem.where('player_id = ? AND quest_id = ?', player_id, quest_id)
      destroy_items(items)
    end

    def delete_all_player_items(player_id)
      items = RoomItem.where("player_id = ? ", player_id)
      destroy_items(items)
    end

    def destroy_items(items_arr)
      items_arr.each do |item|
        item.destroy
      end
    end
  end
end
