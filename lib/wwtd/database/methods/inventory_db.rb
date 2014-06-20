module WWTD
  class ActiveRecordDatabase
    # may be able to refactor by grabbing room_item ar object
    def create_inventory(attrs)
      room_id = get_item(attrs[:item_id]).room_id
      delete_player_room_item(attrs[:player_id], room_id, attrs[:item_id])
      Inventory.create!(attrs)
    end

    def get_player_inventory(player_id)
      result = []
      ar_player = Player.find(player_id)
      inventory_items = ar_player.items
      inventory_items.each do |item|
        result << build_item(item)
      end
      result
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