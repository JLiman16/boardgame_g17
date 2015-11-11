require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should reject usernames not on bgg" do
    get(:link_account, :id => "4", :account_name => "Thisaccountshouldnotexist")
    assert flash[:danger] == "Boardgame Geek Account Not Found"
  end
  
  test "should accept username found on bgg" do
    #eekspider is account known to exist
    get(:link_account, :id => "4", :account_name => "eekspider")
    assert flash[:success] == "Boardgame Geek Account saved"
end
