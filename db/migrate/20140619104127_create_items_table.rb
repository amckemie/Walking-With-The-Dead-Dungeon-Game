class CreateItemsTable < ActiveRecord::Migration
  create_table :items do |t|
    t.string :name, null: false
    t.text :description, null: false
    t.string :classification
  end
end
