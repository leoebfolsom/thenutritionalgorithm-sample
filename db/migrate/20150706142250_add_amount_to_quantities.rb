class AddAmountToQuantities < ActiveRecord::Migration
  def change
    add_column :quantities, :amount, :integer
  end
end
