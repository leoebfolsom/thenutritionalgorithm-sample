class AddFoodStoreIdToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :food_store_id, :integer
  end
end
