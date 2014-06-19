class UpdateStrengthColumnOnPlayersTable < ActiveRecord::Migration
  def up
    change_column :players, :strength, :integer, :default => 100
  end
end
