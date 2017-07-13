require 'test_helper'

class FoodsIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @food = foods(:grape)
  end
  
  test "index including pagination" do
    get foods_path
    assert_template 'foods/index'
    assert_select 'div.pagination'
    Food.paginate(page: 1).each do |food|
      assert_select 'a[href=?]', food_path(food), text: food.name
    end
  end
  
  test "index including pagination and delete links" do
    get foods_path
    assert_template 'foods/index'
    assert_select 'div.pagination'
    first_page_of_foods = Food.paginate(page: 1)
    first_page_of_foods.each do |food|
      assert_select 'a[href=?]', food_path(food), text: food.name
      assert_select 'a[href=?]', food_path(food), text: 'delete'
    end
    assert_difference 'Food.count', -1 do
      delete food_path(@food)
    end
  end


end
