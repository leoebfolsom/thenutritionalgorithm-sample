class AddTotalVitaminATotalVitaminCTotalCalciumTotalIronTotalSodiumToLists < ActiveRecord::Migration
  def change
    add_column :lists, :total_vitamin_a, :integer, :default => 0
    add_column :lists, :total_vitamin_c, :integer, :default => 0
    add_column :lists, :total_calcium, :integer, :default => 0
    add_column :lists, :total_iron, :float, :default => 0
    add_column :lists, :total_sodium, :integer, :default => 0
  end
end
