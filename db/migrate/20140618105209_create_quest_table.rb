class CreateQuestTable < ActiveRecord::Migration
  create_table :quests do |t|
    t.string :name, null: false
  end
end
