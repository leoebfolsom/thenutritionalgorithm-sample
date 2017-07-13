class AddTotalPriceToLists < ActiveRecord::Migration
  def change
    add_column :lists, :total_price, :float, :default => 0
  end
end
