class AddRoomIdToItemsTable < ActiveRecord::Migration
  def up
    add_column :items, :room_id, :integer
  end
end
