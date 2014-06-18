class UpdateCharactersTableTypeColumn < ActiveRecord::Migration
  def up
    rename_column :characters, :type, :classification
  end
end
