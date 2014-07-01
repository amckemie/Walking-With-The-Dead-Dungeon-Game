class RemoveRoomIdDefaultFromPlayerTable < ActiveRecord::Migration
  change_column_default(:players, :room_id, nil)
end
