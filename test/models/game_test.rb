require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "check if game matches image" do
    game = Game.find_by_bggid("10547")
    assert game.thumbnail == "image"
  end
  
  test "check to make sure game has bggid" do
    game = Game.new(:bggid => '')
    assert_not game.save
  end
  
  test "check to make sure game has bgname" do
    game = Game.new(:bgname => '')
    assert_not game.save
  end
end
