class AddTotalPotassiumToLists < ActiveRecord::Migration
  def change
    add_column :lists, :total_potassium, :integer, :default => 0
  end
end
