class Game < ActiveRecord::Base
  has_many :bgg_accounts
  has_many :users, :through => :bgg_accounts
  has_and_belongs_to_many :mechanics
  has_and_belongs_to_many :categories
  serialize :boardgamecategory
  serialize :boardgamemechanic
  serialize :boardgamedesigner
  serialize :boardgameexpansion
  serialize :boardgamepublisher
  
  scope :maximum_age, ->(maxage) { where("minage <= ?", maxage) }
end
