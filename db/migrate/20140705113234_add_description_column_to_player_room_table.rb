class AddDescriptionColumnToPlayerRoomTable < ActiveRecord::Migration
  def up
    add_column :player_rooms, :description, :text
  end
end
