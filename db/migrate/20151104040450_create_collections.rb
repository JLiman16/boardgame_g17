class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.references :bgg_account, index: true, foreign_key: true
      t.string :bggid
      t.string :bgname
      t.string :yearpublished
      t.string :minplayers
      t.string :maxplayers
      t.string :playingtime
      t.string :minplayingtime
      t.string :maxplayingtime
      t.string :minage
      t.text :boardgamecategory
      t.text :boardgamemechanic
      t.text :boardgamedesigner
      t.text :boardgamepublisher
      t.text :boardgameexpansion

      t.timestamps null: false
    end
  end
end
