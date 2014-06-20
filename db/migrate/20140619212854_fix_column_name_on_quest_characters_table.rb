class FixColumnNameOnQuestCharactersTable < ActiveRecord::Migration
  def up
    add_column :quest_characters, :char_id, :integer, :null => false
  end
  def down
    remove_column :quest_characters, :item_id, :integer
  end
end
