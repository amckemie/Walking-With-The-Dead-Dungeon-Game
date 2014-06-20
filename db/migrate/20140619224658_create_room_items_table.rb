class CreateRoomItemsTable < ActiveRecord::Migration
  create_table :room_items do |t|
    t.belongs_to :quest, null: false
    t.belongs_to :room, null: false
    t.belongs_to :player, null: false
    t.belongs_to :item, null: false
    t.integer :parent_item_id
  end
  add_index :room_items, [:player_id, :room_id, :item_id]
  add_index :room_items, [:player_id, :quest_id]
end
