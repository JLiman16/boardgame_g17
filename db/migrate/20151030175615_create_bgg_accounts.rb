class CreateBggAccounts < ActiveRecord::Migration
  def change
    create_table :bgg_accounts do |t|
      t.string :account_name
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
