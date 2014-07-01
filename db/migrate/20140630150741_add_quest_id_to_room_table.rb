class AddQuestIdToRoomTable < ActiveRecord::Migration
  change_table :rooms do |t|
    t.references :quest
  end
end
