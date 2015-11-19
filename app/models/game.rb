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
  
  def self.create_game(objectid)
    game_info = Nokogiri::HTML(open('https://www.boardgamegeek.com/xmlapi2/thing?id=' + objectid.to_s + '&stats=1'))
    
    if Game.exists?(:bggid => objectid.to_s) then
      return false
    end
    
    unless not game_info.css('item')[0].nil? and game_info.css('item')[0]['type'] == 'boardgame'
      return false
    end
    
    unless game_info.css('usersrated')[0]["value"].to_i >= 10
      return false
    end
    
    new_game = Game.new
    new_game.bggid = objectid
    new_game.bgname = game_info.css('name')[0]["value"]
    new_game.save()
    new_game.yearpublished = game_info.css('yearpublished')[0]["value"]
    new_game.minplayers = game_info.css('minplayers')[0]["value"]
    new_game.maxplayers = game_info.css('maxplayers')[0]["value"]
    new_game.playingtime = game_info.css('playingtime')[0]["value"]
    new_game.minplayingtime = game_info.css('minplaytime')[0]["value"]
    new_game.maxplayingtime = game_info.css('maxplaytime')[0]["value"]
    new_game.minage = game_info.css('minage')[0]["value"]
    new_game.thumbnail = game_info.css('thumbnail').first.text
    
    for mechanic in game_info.css("link[type='boardgamemechanic']") do
      if Mechanic.exists?(boardgamemechanic: mechanic["value"])
        new_game.mechanics << Mechanic.find_by_boardgamemechanic(mechanic["value"])
      else
        new_game.mechanics.create(boardgamemechanic: mechanic["value"])
      end
    end
      
    for category in game_info.css("link[type='boardgamecategory']") do
      if Category.exists?(boardgamecategory: category["value"])
        new_game.categories << Category.find_by_boardgamecategory(category["value"])
      else
        new_game.categories.create(boardgamecategory: category["value"])
      end
    end
        
    unless new_game.save()
      return false
    end
    
    return true
  end
  
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
