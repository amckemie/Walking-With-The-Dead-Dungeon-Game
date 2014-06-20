class AddIndexToQuestCharactersTable < ActiveRecord::Migration
  add_index :quest_characters, :player_id
end
