require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "Should destroy session" do
    delete :destroy
    assert_response :redirect
  end
  
  test "Should reject non existant user" do
    post :create, :session => {:username => "Blahbedy", :password => "password", :remember_me => "1"}
    assert flash[:danger] == 'Invalid username/password combination'
  end
  
  test "Should reject existing user if password wrong" do
    post :create, :session => {:username => "petesuncle", :password => "thisisnotapassword", :remember_me => "1"}
    assert flash[:danger] == 'Invalid username/password combination'
  end
end
