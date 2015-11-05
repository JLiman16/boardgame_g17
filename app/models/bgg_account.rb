class BggAccount < ActiveRecord::Base
  belongs_to :user
  has_many :games, dependent: :destroy
  validates :user_id, presence: true
  
  def build_collection
      xml_file = open('https://www.boardgamegeek.com/xmlapi2/collection?username=' + self.account_name)
      collection_docs = Nokogiri::HTML(xml_file)
      
      for game in collection_docs.css('item') do
          game_info = Nokogiri::HTML(open('https://www.boardgamegeek.com/xmlapi2/thing?id=' + game['objectid']))
          @game = self.games.build()
          @game.bggid = game['objectid']
          @game.bgname = game_info.css('name')[0]["value"]
          @game.yearpublished = game_info.css('yearpublished')[0]["value"]
          @game.minplayers = game_info.css('minplayers')[0]["value"]
          @game.maxplayers = game_info.css('maxplayers')[0]["value"]
          @game.playingtime = game_info.css('playingtime')[0]["value"]
          @game.minplayingtime = game_info.css('minplaytime')[0]["value"]
          @game.maxplayingtime = game_info.css('maxplaytime')[0]["value"]
          @game.minage = game_info.css('minage')[0]["value"]
          temp_array = []
          for category in game_info.css("link[type='boardgamecategory']") do
              temp_array << category["value"]
          end
          @game.boardgamecategory = temp_array
          temp_array = []
          for mechanic in game_info.css("link[type='boardgamemechanic']") do
              temp_array << mechanic["value"]
          end
          @game.boardgamemechanic = temp_array
          @game.save
          sleep(1)
      end
  end
end
