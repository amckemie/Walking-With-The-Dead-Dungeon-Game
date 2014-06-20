module WWTD
  class ActiveRecordDatabase
    # may be able to refactor by grabbing room_item ar object
    def create_inventory(attrs)
      Inventory.create!(attrs)
      # add starting value room id to items (can be set to nil once moved to a person)
      room_id = QuestItem.where('')
      delete_player_room_item(attrs[:player_id], room_id, attrs[:item_id])
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
  end
end
