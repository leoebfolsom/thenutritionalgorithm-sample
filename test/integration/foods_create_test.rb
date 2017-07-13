require 'test_helper'

class FoodsCreateTest < ActionDispatch::IntegrationTest
  
  test "invalid food creation" do
    get addfood_path
    assert_no_difference 'Food.count' do
      post foods_path, food: { name: "",
                               calories: "",
                               carbohydrates: "",
                               fat: "",
                               protein: "",
                               sugar: "",
                               potassium: "",
                               fiber: "",
                               calcium: "",
                               vitamin_a: "",
                               vitamin_c: "",
                               iron: "",
                               sodium: "",
                               price: "",
                               food_store: "",
                               food_store_id: "",
                               aisle: ""
      }
    end
    assert_template 'foods/new'
  end
  
  test "valid food creation" do
    get addfood_path
    assert_difference 'Food.count', 1 do
      post_via_redirect foods_path, food: { name:  "exampleburger",
                                            calories: 1,
                                            carbohydrates: 1,
                                            fat: 1,
                                            protein: 1,
                                            sugar: 1,
                                            potassium: 1,
                                            fiber: 1,
                                            calcium: 1,
                                            vitamin_a: 1,
                                            vitamin_c: 1,
                                            iron: 1,
                                            sodium: 1,
                                            price: 1,
                                            food_store: "Kwik-E-Mart",
                                            food_store_id: 1,
                                            aisle: "Produce"
      }
    end
    assert_template 'foods/show'
  end
end
