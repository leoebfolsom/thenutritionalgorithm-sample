require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  
  def setup
    @food = Food.new(name: "exampleburger", 
                     calories: 2, 
                     carbohydrates: 2, 
                     fat: 2,
                     protein: 2,
                     sugar: 2,
                     potassium: 2,
                     fiber: 2, 
                     calcium: 1, 
                     vitamin_a: 2,
                     vitamin_c: 2,
                     iron: 2, 
                     sodium: 2, 
                     price: 1, 
                     food_store: "examplemart",
                     food_store_id: 1234,
                     aisle: "Produce")
  end

  test "should be valid" do
    assert @food.valid?
  end
  
  test "food name should be present" do
    @food.name = "    "
    assert_not @food.valid?
  end
  
  test "food calories should be present" do
    @food.calories = ""
    assert_not @food.valid?
  end
  
  test "food carbohydrates should be present" do
    @food.carbohydrates = ""
    assert_not @food.valid?
  end
  
  test "food fat should be present" do
    @food.fat = ""
    assert_not @food.valid?
  end
  
  test "food protein should be present" do
    @food.protein = ""
    assert_not @food.valid?
  end
  
  test "food sugar should be present" do
    @food.sugar = ""
    assert_not @food.valid?
  end
  
  test "food potassium should be present" do
    @food.potassium = ""
    assert_not @food.valid?
  end
  
  test "food fiber should be present" do
    @food.fiber = ""
    assert_not @food.valid?
  end
  
  test "food calcium should be present" do
    @food.calcium = ""
    assert_not @food.valid?
  end
  
  test "food vitamin_a should be present" do
    @food.vitamin_a = ""
    assert_not @food.valid?
  end
  
  test "food vitamin_c should be present" do
    @food.vitamin_c = ""
    assert_not @food.valid?
  end
  
  test "food iron should be present" do
    @food.iron = ""
    assert_not @food.valid?
  end
  
  test "food sodium should be present" do
    @food.sodium = ""
    assert_not @food.valid?
  end
  
  test "food price should be present" do
    @food.price = ""
    assert_not @food.valid?
  end
  
  test "food food_store should be present" do
    @food.food_store = "    "
    assert_not @food.valid?
  end
  
  test "food food_store_id should be present" do
    @food.food_store_id = "    "
    assert_not @food.valid?
  end
  
  test "food aisle should be present" do
    @food.aisle = "    "
    assert_not @food.valid?
  end
  
  test "food name should not be too long" do
    @food.name = "a" * 151
    assert_not @food.valid?
  end
  
  test "food name should be unique" do
    duplicate_food = @food.dup
    duplicate_food.name = @food.name.upcase
    @food.save
    assert_not duplicate_food.valid?
  end
  
end
