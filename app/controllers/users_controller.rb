class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :show]
  before_action :correct_user,   only: [:edit, :update, :show]

  def show
    @user = User.find(params[:id])
    @all_games = @user.games
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.accounts = []
    if @user.save
      log_in @user
      flash[:success] = "Thank you for making an account at Bored? Game!"
      redirect_to @user
    else
      render 'new'
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
    redirect_to @user
  end
  
  def unlink_account
    @user = User.find(params[:id])
    for game in BggAccount.where(account_name: params[:account])
      game.destroy
    end
    @user.accounts.delete(params[:account])
    @user.save
    redirect_to @user
  end

  private
    
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
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
