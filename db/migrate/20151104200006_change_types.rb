class ChangeTypes < ActiveRecord::Migration
  def up
   change_column :games, :yearpublished, :integer
   change_column :games, :minplayers, :integer
   change_column :games, :maxplayers, :integer
   change_column :games, :playingtime, :integer
   change_column :games, :minplayingtime, :integer
   change_column :games, :maxplayingtime, :integer
   change_column :games, :minage, :integer
  end

  def down
   change_column :games, :yearpublished, :string
   change_column :games, :minplayers, :string
   change_column :games, :maxplayers, :string
   change_column :games, :playingtime, :string
   change_column :games, :minplayingtime, :string
   change_column :games, :maxplayingtime, :string
   change_column :games, :minage, :string
  end
end
