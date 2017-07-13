class AddPercentageToQuantities < ActiveRecord::Migration
  def change
  	add_column :quantities, :percentage, :integer, :default => 100
  end
end
