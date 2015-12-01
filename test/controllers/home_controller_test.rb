require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  test "should get homepage" do
    get :homepage
    assert_response :success
  end
  
  test "home title" do
    get :homepage
    assert_response :success
    assert_select "title", "Bored?Game!"
  end
  
end
