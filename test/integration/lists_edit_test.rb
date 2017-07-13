require 'test_helper'

class ListsEditTest < ActionDispatch::IntegrationTest

  def setup
    @list = lists(:weekend)
  end

  test "unsuccessful edit" do
    get edit_list_path(@list)
    assert_template 'lists/edit'
    patch list_path(@list), list: { days: "a",
                                    name:  "a" * 141,
                                    age: "",
                                    gender: "",
                                    store: "",
                                    max_price: ""
                      #              total_calories: "",
                      #              total_carbohydrates: "",
                      #              total_potassium: "",
                      #              total_fiber: "",
                      #              total_calcium: "",
                      #              total_iron: "",
                      #              total_sodium: ""
                                  }
    assert_template 'lists/edit'
  end
  
  test "successful edit" do
    get edit_list_path(@list)
    assert_template 'lists/edit'
    days = 2
    name  = "the weekend"
    age = 26
    gender = "m"
    store = "Kwik-E-Mart"
    max_price = 1.00
   # total_calories = 3
   # total_carbohydrates = 2
   # total_potassium = 3
   # total_fiber = 2
   # total_calcium = 1
   # total_iron = 1
   # total_sodium = 1
    patch list_path(@list), list: { name:  name,
                                    days: days,
                                    age: age,
                                    gender: gender,
                                    store: store,
                                    max_price: max_price
                                  #  total_calories: total_calories,
                                  #  total_carbohydrates: total_carbohydrates,
                                  #  total_potassium: total_potassium,
                                  #  total_fiber: total_fiber,
                                  #  total_calcium: total_calcium,
                                  #  total_iron: total_iron,
                                  #  total_sodium: total_sodium
                                  }
    assert_not flash.empty?
    assert_redirected_to @list
    @list.reload
    assert_equal name,  @list.name
    assert_equal days, @list.days
    assert_equal age, @list.age
    assert_equal gender, @list.gender
    assert_equal store, @list.store
    assert_equal max_price, @list.max_price
  #  assert_equal total_calories, @list.total_calories
  #  assert_equal total_carbohydrates, @list.total_carbohydrates
  #  assert_equal total_potassium, @list.total_potassium
  #  assert_equal total_fiber, @list.total_fiber
  #  assert_equal total_calcium, @list.total_calcium
  #  assert_equal total_iron, @list.total_iron
  #  assert_equal total_sodium, @list.total_sodium
  end
  
end