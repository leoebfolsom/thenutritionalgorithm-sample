class AddAteAtAndBoughtAtToQuantities < ActiveRecord::Migration
  def change
    add_column :quantities, :ate_at, :datetime, :default => nil
    add_column :quantities, :bought_at, :datetime, :default => nil    
  end
end
