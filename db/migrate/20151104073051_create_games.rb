class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :bggid
      t.string :bgname
      t.integer :yearpublished
      t.integer :minplayers
      t.integer :maxplayers
      t.integer :playingtime
      t.integer :minplayingtime
      t.integer :maxplayingtime
      t.integer :minage
      t.text :boardgamecategory
      t.text :boardgamemechanic
      t.text :boardgamedesigner
      t.text :boardgamepublisher
      t.text :boardgameexpansion

      t.timestamps null: false
    end
  end
end
