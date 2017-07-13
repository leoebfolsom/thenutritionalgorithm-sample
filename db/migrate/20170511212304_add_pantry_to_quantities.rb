class AddPantryToQuantities < ActiveRecord::Migration
  def change
  	add_column :quantities, :pantry, :integer, :default => 0
  end
end
