require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template 'home/homepage'
    assert_select "a[href=?]", signup_path
    get signup_path
    assert_select "title", "Sign up | Bored?Game!"
  end
end
