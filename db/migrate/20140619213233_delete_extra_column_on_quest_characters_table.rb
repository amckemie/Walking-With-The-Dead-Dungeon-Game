class DeleteExtraColumnOnQuestCharactersTable < ActiveRecord::Migration
  def up
    remove_column :quest_characters, :char_id, :integer
  end
end
