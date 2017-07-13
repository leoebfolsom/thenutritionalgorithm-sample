class AddFoodStoreToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :food_store, :string
  end
end
