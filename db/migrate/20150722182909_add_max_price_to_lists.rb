class AddMaxPriceToLists < ActiveRecord::Migration
  def change
    add_column :lists, :max_price, :float
  end
end
