class AddIngredientsToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :ingredients, :text
  end
end
