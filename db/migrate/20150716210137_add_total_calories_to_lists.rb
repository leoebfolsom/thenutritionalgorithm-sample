class AddTotalCaloriesToLists < ActiveRecord::Migration
  def change
    add_column :lists, :total_calories, :integer, :default => 0
  end
end