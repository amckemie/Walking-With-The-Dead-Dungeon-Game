module WWTD
  class ActiveRecordDatabase
    def create_item(attrs)
      ar_item = Item.create!(attrs)
      build_item(ar_item)
    end

    def build_item(item)
      WWTD::ItemNode.new(item)
    end

    def get_item(item_id)
      ar_item = Item.find(item_id)
      build_item(ar_item)
    end

    def get_first_item
      ar_item = Item.first
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

    def get_item_by_name(name)
      ar_item = Item.find_by(name: name)
      ar_item ? build_item(ar_item) : nil
    end
  end
end
