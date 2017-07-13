class AddAteToQuantities < ActiveRecord::Migration
  def change
    add_column :quantities, :ate, :integer, :default => 0
  end
end
