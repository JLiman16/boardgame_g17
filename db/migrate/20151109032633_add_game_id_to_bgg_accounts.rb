class AddGameIdToBggAccounts < ActiveRecord::Migration
  def change
    add_column :bgg_accounts, :game_id, :integer
  end
end
