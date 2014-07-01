class FixRoomIdColumnOnQuestProgressTable < ActiveRecord::Migration
  change_table :quest_progress do |t|
    t.references :room
  end
end
