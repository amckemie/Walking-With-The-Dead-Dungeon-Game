class CreateQuestCharactersTable < ActiveRecord::Migration
  create_table :quest_characters do |t|
    t.belongs_to :quest,     null: false
    t.belongs_to :room,      null: false
    t.belongs_to :character, null: false
    t.belongs_to :player ,    null: false
  end
  add_index :quest_characters, ["player_id", "character_id"]
  add_index :quest_characters, ["player_id", "quest_id", "room_id"]
end
