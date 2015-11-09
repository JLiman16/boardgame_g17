class AddAccountsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :accounts, :text
  end
end
