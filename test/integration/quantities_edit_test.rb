require 'test_helper'

class QuantitiesEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @quantity = quantities(:one)
  end

  test "unsuccessful edit" do
    get edit_quantity_path(@quantity)
    assert_template 'quantities/edit'
    patch quantity_path(@quantity), quantity: { list_id: "",
                                                food_id: "",
                                                amount: ""
                                  }
    assert_template 'quantities/edit'
  end
  
  test "successful edit" do
    get edit_quantity_path(@quantity)
    assert_template 'quantities/edit'
    list_id = 1
    food_id = 1
    amount = 1
    patch quantity_path(@quantity), quantity: { list_id: list_id,
                                                food_id: food_id,
                                                amount: amount
                                  }
    assert_not flash.empty?
    assert_redirected_to @quantity
    @quantity.reload
    assert_equal list_id,  @quantity.list_id
    assert_equal food_id, @quantity.food_id
    assert_equal amount, @quantity.amount
  end
  
end