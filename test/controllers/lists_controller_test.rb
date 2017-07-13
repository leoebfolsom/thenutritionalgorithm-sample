require 'test_helper'

class ListsControllerTest < ActionController::TestCase
  
  def setup
    @list = lists(:weekend)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

end