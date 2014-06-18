class UpdateRoomTableBooleanColumns < ActiveRecord::Migration
  def up
    change_column :rooms, :canN, :boolean, :default => true
    change_column :rooms, :canE, :boolean, :default => true
    change_column :rooms, :canS, :boolean, :default => true
    change_column :rooms, :canW, :boolean, :default => true
  end
end
