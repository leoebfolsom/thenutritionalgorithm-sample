require 'test_helper'

class QuantitiesCreateTest < ActionDispatch::IntegrationTest

  test "invalid quantities creation information" do
    get addquantity_path
    assert_no_difference 'Quantity.count' do
      post quantities_path, quantity: { food_id:  "",
                                        list_id: "",
                                        amount: ""
                               }
    end
    assert_template 'quantities/new'
  end
  
  
  test "valid quantities creation information" do
    get addquantity_path
    assert_difference 'Quantity.count', 1 do
      post_via_redirect quantities_path, quantity: { list_id: @list_id,
                                            food_id: @food_id,
                                            amount: 2}
    end
    assert_template 'quantities/show'
  end
  
end