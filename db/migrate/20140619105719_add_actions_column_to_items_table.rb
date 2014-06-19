class AddActionsColumnToItemsTable < ActiveRecord::Migration
  def up
    add_column :items, :actions, :string
  end
end
