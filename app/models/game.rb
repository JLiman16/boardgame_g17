class Game < ActiveRecord::Base
  has_many :bgg_accounts
  has_many :users, :through => :bgg_accounts
  has_and_belongs_to_many :mechanics
  has_and_belongs_to_many :categories
  serialize :boardgamedesigner
  serialize :boardgameexpansion
  serialize :boardgamepublisher
  
  validates :bggid,  presence: true
  validates :bgname,  presence: true
  
  def self.age_range(maxage, minage)
    where("minage <= ? and minage >= ?", maxage, minage)
  end
  
  def self.players_range(num_players)
    where("minplayers <= ? and maxplayers >= ?", num_players, num_players)
  end
  
  def self.time_range(max_time, min_time)
    where(playingtime: min_time..max_time )
  end
  
  def self.filter_mechanics(mechanic)
    self.joins(:mechanics).where("boardgamemechanic = ?", mechanic)
  end
  
  def self.filter_categories(category)
    self.joins(:categories).where("boardgamecategory = ?", category)
  end
end
