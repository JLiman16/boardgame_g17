class Similarity < ActiveRecord::Base
  def self.create_index(game1, game2)
      new_index = Similarity.new
      game1_set = []
      game2_set = []
      for mechanic in game1.mechanics do
          game1_set << mechanic.boardgamemechanic
      end
      for category in game1.categories do
          game1_set << category.boardgamecategory
      end
      for mechanic in game2.mechanics do
          game2_set << mechanic.boardgamemechanic
      end
      for category in game2.categories do
          game2_set << category.boardgamecategory
      end
      new_index.game1_id = game1.id
      new_index.game2_id = game2.id
      new_index.sim_index = (game1_set & game2_set).size.to_f / (game1_set | game2_set).size
      new_index.save()
      return new_index
  end
end