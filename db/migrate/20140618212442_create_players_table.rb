class CreatePlayersTable < ActiveRecord::Migration
  create_table :players do |t|
    t.string :username, null: false
    t.string :password, null: false
    t.text :description
    t.integer :strength, default: 0
    t.boolean :dead, default: false
  end
  add_index :players, :username
end
