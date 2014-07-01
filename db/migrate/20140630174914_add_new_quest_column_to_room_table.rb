class AddNewQuestColumnToRoomTable < ActiveRecord::Migration
  def up
    add_column :rooms, :start_new_quest, :boolean, :default => false
  end
end
