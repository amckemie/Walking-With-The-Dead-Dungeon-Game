class CreateQuestItemsTable < ActiveRecord::Migration
  create_table :quest_items do |t|
    t.belongs_to :item, null: false
    t.belongs_to :quest, null: false
    t.belongs_to :room, null: false
  end
  add_index :quest_items, [:quest_id, :room_id, :item_id]
end
