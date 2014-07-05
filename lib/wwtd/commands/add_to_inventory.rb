require 'ostruct'

module WWTD
  class AddToInventory < Command
    def run(player, item)
      exists = WWTD.db.room_item_exists?(player.id, player.room_id, item.id)
      if exists
        quest_id = WWTD.db.get_latest_quest(player.id).quest_id
        WWTD.db.create_inventory(player.id, player.room_id, item.id, quest_id)
        return success :message => "Item picked up!"
      else
        return failure('That item is not in this room.')
      end
    end
  end
end
