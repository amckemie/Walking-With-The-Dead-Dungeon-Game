class CreateQuestProgressTable < ActiveRecord::Migration
  create_table :quest_progress do |t|
    t.belongs_to :quest, null: false
    t.belongs_to :player, null: false
    t.boolean :complete, default: false
    t.text :data
  end
  add_index :quest_progress, [:player_id, :quest_id]
end
