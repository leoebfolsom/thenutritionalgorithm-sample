class AddTotalFiberToLists < ActiveRecord::Migration
  def change
    add_column :lists, :total_fiber, :integer, :default => 0
  end
end
