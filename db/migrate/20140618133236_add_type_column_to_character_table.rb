class AddTypeColumnToCharacterTable < ActiveRecord::Migration
  def up
    add_column :characters, :type, :string, {null: false}
    change_column :characters, :strength, :integer, :default => 0
  end
end
