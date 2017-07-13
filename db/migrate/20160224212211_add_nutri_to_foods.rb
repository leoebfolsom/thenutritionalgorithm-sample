class AddNutriToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :nutri, :string, :default => ''
  end
end
