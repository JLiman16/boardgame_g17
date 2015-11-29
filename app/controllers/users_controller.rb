class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :show]
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def find_game
    @user = User.find(params[:id])
    if session[:params]
      params.replace(session[:params].merge(params))
    end
    fetch_games
  end
  
  def create
    @user = User.new(user_params)
    @user.accounts = []
    @user.last_login = Time.zone.now
    if @user.save
      log_in @user
      flash[:success] = "Thank you for making an account at Bored? Game!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def index
    if User.exists?(username: params[:user_wanted])
      redirect_to User.find_by(username: params[:user_wanted])
    else
      flash[:danger] = "User not found"
      redirect_to request.referer
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def link_account
    @user = User.find(params[:id])
    #Check for account existence on BGG
    xml_file = open('https://www.boardgamegeek.com/xmlapi2/collection?username=' + params[:account_name])
    collection_docs = Nokogiri::HTML(xml_file)
    if collection_docs.css('message').text == "Invalid username specified"
      flash[:danger] = "Boardgame Geek Account Not Found"
      redirect_to @user and return
    end
    
    #Save the account name
    #temp_array = @user.accounts
    @user.accounts << params[:account_name]
    @user.save
    #@user.accounts = temp_array 
    
    #BGG Queues requests and spits out a 202 status code until the report is generated
    while xml_file.status[0] == '202' do
      sleep(1)
      xml_file = open('https://www.boardgamegeek.com/xmlapi2/collection?username=' + params[:account_name])
    end
    
    @user.build_collection(params[:account_name])
    
    flash[:success] = "Boardgame Geek Account saved"
    redirect_to find_game_path(@user)
  end
  
  def unlink_account
    @user = User.find(params[:id])
    for game in BggAccount.where(account_name: params[:account])
      game.destroy
    end
    @user.accounts.delete(params[:account])
    @user.save
    flash[:success] = "Account Deleted"
    redirect_to find_game_path(@user)
  end
  
  def filter
    @user = User.find(params[:id])
    session[:params] = params
    session[:params].delete_if { |key, value| value.blank? }
    redirect_to find_game_path(@user)
  end
  
  def collection
    @user = User.find(params[:id])
    unless params[:game_id].nil? or @user != current_user
      @user.bgg_accounts.where("game_id = ? AND user_id = ?", params[:game_id], params[:id]).take.toggle!(:favorite)
      redirect_to collection_path
    end
    @all_games = @user.games.distinct
  end
  
  def suggest_game
    similar_games = Similarity.where("game1_id = ? OR game2_id = ?", params[:game_id].to_i, params[:game_id].to_i).order(sim_index: :desc).limit(10)
    @game_to_compare = Game.find(params[:game_id].to_i)
    unless params[:add_game].nil?
      @user = User.find(params[:id])
      unless BggAccount.where("user_id = ? AND game_id = ?", @user, params[:add_game]).exists?
        @user.bgg_accounts.create(game: Game.find(params[:add_game].to_i), favorite: "f")
      end
    end
    @suggestions = []
    for game in similar_games do
      if game.game1_id == params[:game_id].to_i
        @suggestions << Game.find(game.game2_id)
      else
        @suggestions << Game.find(game.game1_id)
      end
    end
    find_game
    render :find_game
  end

  private
    
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :picture)
  end
  
  def fetch_games
    defaults = { min_age: '0', max_age: '1000', sort: 'bgname', direction: 'asc', num_players: '0', min_time: '0', max_time: '10000', favorites: false }
    params.replace(defaults.merge(params))
    
    if params[:favorites] == "1"
      params[:favorites] = "t"
    end
    
    @all_games = @user.games.where("favorite = ?", params[:favorites])
    
    @all_games = @all_games.age_range(params[:max_age], params[:min_age])
    
    unless params[:num_players].to_i <= 0
      @all_games = @all_games.players_range(params[:num_players])
    end
    
    @all_games = @all_games.time_range(params[:max_time], params[:min_time])
    
    unless params[:game_mechanic].blank?
      @all_games = @all_games.filter_mechanics(params[:game_mechanic])
    end
   
    unless params[:game_category].blank?
      @all_games = @all_games.filter_categories(params[:game_category])
    end
    
    @all_games = @all_games.order(params[:sort] + " " + params[:direction]).distinct
  end

  # Before filters

  # Confirms a logged-in user. Check later
  #def logged_in_user
  #  unless logged_in?
  #    flash[:danger] = "Please log in."
  #    redirect_to login_url
  #  end
  #end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end
end
