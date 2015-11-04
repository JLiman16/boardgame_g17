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
end
