require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Username exists" do
   user = User.new(
    username: "",
    password: "Thisisjustatest",
    password_confirmation: "Thisisjustatest"
    )
    assert_not user.valid?
  end
  
  test "Username unique" do
    user = User.new(
      username: "Testing",
      password: "Thisisjustatest",
      password_confirmation: "Thisisjustatest"
      )
    user2 = User.new(
      username: "Testing",
      password: "Thisisjustatest",
      password_confirmation: "Thisisjustatest"
      )
      user.save
    assert_not user2.valid?
  end
  
  test "Password exists" do
    user = User.new(
      username: "Testing",
      password: "",
      password_confirmation: ""
      )
    assert_not user.valid?
  end
  
  test "Password length sufficient" do
    user = User.new(
      username: "Testing",
      password: "five",
      password_confirmation: "five"
      )
    assert_not user.valid?
  end
  
  test "Password confirmation matches" do
    user = User.new(
      username: "Testing",
      password: "Thefroggoes",
      password_confirmation: "Hippedyhop"
      )
    assert_not user.valid?
  end
  
  test "name should not be too long" do
    user = User.new(
      username: "a" * 51,
      password: "testpassword",
      password_confirmation: "testpassword"
      )
    assert_not user.valid?
  end
end
