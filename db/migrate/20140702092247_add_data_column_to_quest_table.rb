class AddDataColumnToQuestTable < ActiveRecord::Migration
  def up
    add_column :quests, :data, :text
  end
end
