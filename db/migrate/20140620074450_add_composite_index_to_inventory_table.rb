class AddCompositeIndexToInventoryTable < ActiveRecord::Migration
  add_index :inventory, [:player_id, :item_id]
end
