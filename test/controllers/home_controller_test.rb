require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  # test "the truth" do
  #   assert true
  # end
  
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
