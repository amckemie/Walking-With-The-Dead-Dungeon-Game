module WWTD
  class ActiveRecordDatabase
    # may be able to refactor by grabbing room_item ar object
    def create_inventory(room_item)
      delete_player_room_item(room_item.player_id, room_item.room_id, room_item.item_id)
      Inventory.create!(player_id: room_item.player_id, item_id: room_item.item_id, quest_id: room_item.quest_id)
    end

    def build_inventory(inventory_arr)
      result = []
      inventory_arr.each do |item|
        result << build_item(item)
      end
      result
    end

    def get_player_inventory(player_id)
      ar_player = Player.find(player_id)
      inventory_items = ar_player.items
      build_inventory(inventory_items)
    end

    def delete_inventory_item(player_id, item_id)
      ar_inventory_item = Inventory.where("player_id = ? AND item_id = ?", player_id, item_id).first
      ar_inventory_item.destroy
    end

    def delete_inventory_from_quest(player_id, quest_id)
      inventory_items = Inventory.where("player_id = ? AND quest_id = ?", player_id, quest_id)
      inventory_items.each do |item|
        item.destroy
      end
    end
  end
end
