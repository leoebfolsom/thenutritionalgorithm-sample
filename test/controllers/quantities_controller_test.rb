require 'test_helper'

class QuantitiesControllerTest < ActionController::TestCase

  def setup
    @quantity = quantities(:one)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

end