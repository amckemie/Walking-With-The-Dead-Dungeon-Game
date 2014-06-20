class AddRoomIdDefaultToPlayersTable < ActiveRecord::Migration
  def up
    change_column :players, :room_id, :integer, :default => 1
  end
end
