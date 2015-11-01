class BggAccountsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    
    def create
        @bgg_account = current_user.bgg_accounts.build(bgg_account_params)
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
