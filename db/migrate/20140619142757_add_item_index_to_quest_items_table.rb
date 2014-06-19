class AddItemIndexToQuestItemsTable < ActiveRecord::Migration
  def up
    add_index :quest_items, :item_id
  end
end
