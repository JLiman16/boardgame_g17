class CreateSimilarities < ActiveRecord::Migration
  def change
    create_table :similarities do |t|
      t.integer :game1_id
      t.integer :game2_id
      t.float :sim_index
    end
  end
end
