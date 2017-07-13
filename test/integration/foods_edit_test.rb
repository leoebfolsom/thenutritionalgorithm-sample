require 'test_helper'

class FoodsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @food = foods(:grape)
  end

  test "unsuccessful edit" do
    get edit_food_path(@food)
    assert_template 'foods/edit'
    patch food_path(@food), food: { name: "",
                                    calories: "",
                                    carbohydrates: "",
                                    fat: "",
                                    protein: "",
                                    sugar: "",
                                    potassium: "",
                                    fiber: "",
                                    vitamin_a: "",
                                    vitamin_c: "",
                                    calcium: "",
                                    iron: "",
                                    sodium: "",
                                    price: "",
                                    food_store: "Kwik-E-Mart",
                                    food_store_id: "",
                                    aisle: ""
    }
    assert_template 'foods/edit'
  end
  
  test "successful edit" do
    get edit_food_path(@food)
    assert_template 'foods/edit'
    name  = "foo bar"
    calories = 12,
    carbohydrates = 4,
    fat = 1,
    protein = 1,
    sugar = 1,
    potassium = 3,
    fiber = 1,
    vitamin_a = 1,
    vitamin_c = 1,
    calcium = 1,
    iron = 1,
    sodium = 1,
    price = 1,
    food_store = "Kwik-E-Mart",
    food_store_id = 1,
    aisle = "produce"
    patch food_path(@food), food: { name:  name,
                                    calories: calories,
                                    carbohydrates: carbohydrates,
                                    fat: fat,
                                    protein: protein,
                                    sugar: sugar,
                                    potassium: potassium,
                                    fiber: fiber,
                                    vitamin_a: vitamin_a,
                                    vitamin_c: vitamin_c,
                                    calcium: calcium,
                                    iron: iron,
                                    sodium: sodium,
                                    price: price,
                                    food_store: food_store,
                                    food_store_id: food_store_id,
                                    aisle: aisle
    }
    assert_not flash.empty?
    assert_redirected_to @food
    @food.reload
    assert_equal name,  @food.name
    assert_equal calories, @food.calories
    assert_equal carbohydrates, @food.carbohydrates
    assert_equal fat, @food.fat
    assert_equal protein, @food.protein
    assert_equal sugar, @food.sugar
    assert_equal potassium, @food.potassium
    assert_equal fiber, @food.fiber
    assert_equal vitamin_a, @food.vitamin_a
    assert_equal vitamin_c, @food.vitamin_c
    assert_equal calcium, @food.calcium
    assert_equal iron, @food.iron
    assert_equal sodium, @food.sodium
    assert_equal price, @food.price
    assert_equal food_store, @food.food_store
    assert_equal food_store_id, @food.food_store_id
    assert_equal aisle, @food.aisle
  end
end