class AddPlayerIdColumnToQuestCharactersTable < ActiveRecord::Migration
  def up
    add_column :quest_characters, :player_id, :integer, :null => false
  end
end
