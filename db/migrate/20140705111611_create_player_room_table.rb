class CreatePlayerRoomTable < ActiveRecord::Migration
  create_table :player_rooms do |t|
    t.belongs_to :player, null: false
    t.belongs_to :room, null: false
    t.belongs_to :quest
    t.boolean :canN, default: true
    t.boolean :canE, default: true
    t.boolean :canS, default: true
    t.boolean :canW, default: true
    t.boolean :start_new_quest, default: false
  end
  add_index :player_rooms, [:player_id, :room_id]
end
