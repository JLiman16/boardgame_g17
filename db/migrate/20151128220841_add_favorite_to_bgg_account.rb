class AddFavoriteToBggAccount < ActiveRecord::Migration
  def change
    add_column :bgg_accounts, :favorite, :boolean
  end
end
