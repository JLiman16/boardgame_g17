class RemoveMechanic < ActiveRecord::Migration
  def change
    remove_column :games, :boardgamemechanic, :text
    remove_column :games, :boardgamecategory, :text
  end
end
