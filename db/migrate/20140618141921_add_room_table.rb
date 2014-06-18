class AddRoomTable < ActiveRecord::Migration
  create_table :rooms do |t|
    t.string :name, null: false
    t.text :description, null: false
    t.integer :north
    t.integer :east
    t.integer :south
    t.integer :west
    t.boolean :canN
    t.boolean :canE
    t.boolean :canS
    t.boolean :canW
  end
end
