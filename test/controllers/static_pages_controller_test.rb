require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "Load home page" do
    get :home
    assert_response :success
    assert_select "title", "the nutrition algorithm"
  end

  test "Load about page" do
    get :about
    assert_response :success
    assert_select "title", "about | the nutrition algorithm"
  end
  
  test "Load contact page" do
    get :contact
    assert_response :success
    assert_select "title", "get in touch! | the nutrition algorithm"
  end

end
