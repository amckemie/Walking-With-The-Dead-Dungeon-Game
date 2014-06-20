module WWTD
  class ActiveRecordDatabase
    def create_item(attrs)
      ar_item = Item.create!(attrs)
      build_item(ar_item)
    end

    def build_item(item)
      WWTD::ItemNode.new(id: item.id,
        classification: item.classification,
        name: item.name,
        description: item.description,
        actions: item.actions,
        parent_item: item.parent_item,
        room_id: item.room_id
      )
    end

    def get_item(item_id)
      ar_item = Item.find(item_id)
      build_item(ar_item)
    end

    def update_item(item_id, data)
      ar_item = Item.find(item_id)
      ar_item.update(data)
      build_item(ar_item)
    end

    def delete_item(item_id)
      ar_item = Item.find(item_id)
      ar_item.destroy
      return true if !Item.exists?(item_id)
    end
  end
end
