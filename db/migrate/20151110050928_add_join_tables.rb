class AddJoinTables < ActiveRecord::Migration
  def change
    create_table :mechanics do |t|
      t.string :boardgamemechanic
      t.timestamps null: false
    end
 
    create_table :games_mechanics, id: false do |t|
      t.belongs_to :mechanic, index: true
      t.belongs_to :game, index: true
    end
    
    create_table :categories do |t|
      t.string :boardgamecategory
      t.timestamps null: false
    end
 
    create_table :categories_games, id: false do |t|
      t.belongs_to :category, index: true
      t.belongs_to :game, index: true
    end
    
  end
end
