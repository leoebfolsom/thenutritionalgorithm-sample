require 'test_helper'

class FoodsControllerTest < ActionController::TestCase
  
  def setup
    @food = foods(:grape)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

end
