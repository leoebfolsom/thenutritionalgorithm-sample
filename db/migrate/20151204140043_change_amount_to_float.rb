class ChangeAmountToFloat < ActiveRecord::Migration
  def change
  	change_column :quantities, :amount, :float
  end
end
