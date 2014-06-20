class ChangeIndexForPlayerAndQuestOnQuestCharactersTable < ActiveRecord::Migration
  def up
    add_index :quest_characters, [:player_id, :quest_id]
  end
end
