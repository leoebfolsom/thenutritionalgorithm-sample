class AddVitaminAVitaminCCalciumIronSodiumToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :vitamin_a, :integer
    add_column :foods, :vitamin_c, :integer
    add_column :foods, :calcium, :integer
    add_column :foods, :iron, :float
    add_column :foods, :sodium, :integer
  end
end
