class CreateInventoryTable < ActiveRecord::Migration
  create_table :inventory do |t|
    t.belongs_to :player, null: false
    t.belongs_to :item, null: false
    t.belongs_to :quest, null: false
  end
  add_index :inventory, [:player_id, :quest_id]

end
