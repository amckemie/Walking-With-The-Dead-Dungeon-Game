class AddCharacterIndexToQuestCharactersTable < ActiveRecord::Migration
  def up
    add_index :quest_characters, [:player_id, :character_id]
  end
end
