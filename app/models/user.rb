class User < ActiveRecord::Base
  has_many :bgg_accounts, dependent: :destroy
  has_many :games, :through => :bgg_accounts
  accepts_nested_attributes_for :bgg_accounts , :games
  attr_accessor :remember_token
  mount_uploader :picture, PictureUploader
  validates :username,  presence: true, length: { maximum: 50 },
                        uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  serialize :accounts
  validate  :picture_size
  
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def build_collection(username)
    xml_file = open('https://www.boardgamegeek.com/xmlapi2/collection?username=' + username)
    collection_docs = Nokogiri::HTML(xml_file)
    
    for game in collection_docs.css('item') do
      if Game.exists?(bggid: game['objectid']) then
          unless self.bgg_accounts.where("game_id = ?", Game.find_by_bggid(game['objectid'])).exists?
            self.bgg_accounts.create(game: Game.find_by_bggid(game['objectid']), account_name: username, favorite: "f")
          end
      else
        game_info = Nokogiri::HTML(open('https://www.boardgamegeek.com/xmlapi2/thing?id=' + game['objectid']))
        new_game = Game.new
        new_game.bggid = game['objectid']
        new_game.bgname = game_info.css('name')[0]["value"]
        new_game.save()
        self.bgg_accounts.create(game: new_game, account_name: username)
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

        new_game.save()
        for game in Game.all do
          Similarity.create_index(game, new_game)
        end
        #Bgg will return an error if the site is queried too often
        sleep(1)
      end
    end
  end
  handle_asynchronously :build_collection

  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
