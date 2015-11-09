class Game < ActiveRecord::Base
  has_many :bgg_accounts
  has_many :users, :through => :bgg_accounts
  serialize :boardgamecategory
  serialize :boardgamemechanic
  serialize :boardgamedesigner
  serialize :boardgameexpansion
  serialize :boardgamepublisher
  
  scope :maximum_age, ->(maxage) { where("minage <= ?", maxage) }
end
