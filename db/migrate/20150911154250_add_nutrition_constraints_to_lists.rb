class AddNutritionConstraintsToLists < ActiveRecord::Migration
  def change
    add_column :lists, :nutrition_constraints, :json, default: '[]'
  end
end
