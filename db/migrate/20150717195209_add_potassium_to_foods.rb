class AddPotassiumToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :potassium, :integer
  end
end
