class BggAccountsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    
    def create
        @bgg_account = current_user.bgg_accounts.build(bgg_account_params)
        
        xml_file = open('https://www.boardgamegeek.com/xmlapi2/collection?username=' + @bgg_account.account_name)
        collection_docs = Nokogiri::HTML(xml_file)
        if collection_docs.css('message').text == "Invalid username specified"
            flash[:danger] = "Boardgame Geek Account Not Found"
            redirect_to current_user and return
        end
        
        #BGG Queues requests and spits out a 202 status code until the report is generated
        while xml_file.status[0] == '202' do
            sleep(1)
            xml_file = open('https://www.boardgamegeek.com/xmlapi2/collection?username=' + @bgg_account.account_name)
            collection_docs = Nokogiri::HTML(xml_file)
        end
        
        build_collection(collection_docs)
        
        if @bgg_account.save
            flash[:success] = "Boardgame Geek Account saved"
            redirect_to current_user
        else
            redirect_to current_user
        end
    end
    
    def destroy
        @bgg_account= current_user.bgg_accounts.find_by(id: params[:id])
        @bgg_account.destroy
        flash[:success] = "Account deleted"
        redirect_to current_user
    end
    
    private
    
    def bgg_account_params
      params.require(:bgg_account).permit(:account_name)
    end
    
    def build_collection(collection_docs)
        for game in collection_docs.css('item') do
            game_info = Nokogiri::HTML(open('https://www.boardgamegeek.com/xmlapi2/thing?id=' + game['objectid']))
            @game = @bgg_account.games.build()
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
            @game.save
            sleep(1)
        end
    end
end
