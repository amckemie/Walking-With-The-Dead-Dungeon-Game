class CreateCharacterTable < ActiveRecord::Migration
  create_table :characters do |t|
    t.string :name, null: false
    t.text :description
    t.integer :strength
    t.belongs_to :room
    t.belongs_to :quest
  end
  add_index :characters, :room_id
  add_index :characters, :quest_id
end
