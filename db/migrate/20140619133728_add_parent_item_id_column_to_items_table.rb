class AddParentItemIdColumnToItemsTable < ActiveRecord::Migration
  def up
    add_column :items, :parent_item, :integer, :default => 0
  end
end
