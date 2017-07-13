require 'test_helper'

class QuantityTest < ActiveSupport::TestCase
  def setup
    @list = lists(:weekend)
    @food = foods(:grape)
    @quantity = Quantity.new(amount: 1, food_id: @food.id, list_id: @list.id)
  end
  
  test "should be valid" do
    assert @quantity.valid?
  end

  test "food id should be present" do
    @quantity.food_id = nil
    assert_not @quantity.valid?
  end
  
  test "list id should be present" do
    @quantity.list_id = nil
    assert_not @quantity.valid?
  end
  
  test "amount should be present" do
    @quantity.amount = "   "
    assert_not @quantity.valid?
  end
  
  test "amount should be integer" do
    @quantity.amount = "a"
    assert_not @quantity.valid?
  end
  
end
