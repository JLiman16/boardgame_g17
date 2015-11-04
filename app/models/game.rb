class Game < ActiveRecord::Base
  belongs_to :bgg_account
  serialize :boardgamecategory
  serialize :boardgamemechanic
  serialize :boardgamedesigner
  serialize :boardgameexpansion
  serialize :boardgamepublisher
end
