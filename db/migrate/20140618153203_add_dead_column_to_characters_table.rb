class AddDeadColumnToCharactersTable < ActiveRecord::Migration
  def up
    add_column :characters, :dead, :boolean, :default => false
  end
end
