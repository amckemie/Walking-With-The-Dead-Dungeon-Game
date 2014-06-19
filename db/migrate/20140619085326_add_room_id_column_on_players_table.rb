class AddRoomIdColumnOnPlayersTable < ActiveRecord::Migration
  def up
    add_column :players, :room_id, :integer
  end
end
