class Game < ActiveRecord::Base
  has_many :bgg_accounts
  has_many :users, :through => :bgg_accounts
  has_and_belongs_to_many :mechanics
  has_and_belongs_to_many :categories
  serialize :boardgamedesigner
  serialize :boardgameexpansion
  serialize :boardgamepublisher
  
  def self.age_range(maxage, minage)
    where("minage <= ? and minage >= ?", maxage, minage)
  end
  
  def self.players_range(max_players, min_players)
    where("minplayers <= ? and maxplayers <= ?", min_players, max_players)
  end
  
  def self.time_range(max_time, min_time)
    #where("")
  end
  
  def self.filter_mechanics(mechanic)
    self.joins(:mechanics).where("boardgamemechanic = ?", mechanic)
  end
end
