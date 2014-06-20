class AddCompositeIndexToQuestCharactersTable < ActiveRecord::Migration
  def up
    add_index :quest_characters, [:player_id, :quest_id, :room_id]
    remove_index :quest_characters, [:quest_id, :room_id]
  end
end
