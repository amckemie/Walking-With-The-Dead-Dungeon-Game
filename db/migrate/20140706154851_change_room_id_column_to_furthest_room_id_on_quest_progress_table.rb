class ChangeRoomIdColumnToFurthestRoomIdOnQuestProgressTable < ActiveRecord::Migration
  def up
    remove_column :quest_progress, :room_id
    add_column :quest_progress, :furthest_room_id, :integer, :default => 1
  end
end
