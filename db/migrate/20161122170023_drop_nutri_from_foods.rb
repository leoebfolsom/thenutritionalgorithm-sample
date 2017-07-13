class DropNutriFromFoods < ActiveRecord::Migration
  def change
    remove_column :foods, :nutri
  end
end
