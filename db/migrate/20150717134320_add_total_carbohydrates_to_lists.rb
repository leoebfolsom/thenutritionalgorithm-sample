class AddTotalCarbohydratesToLists < ActiveRecord::Migration
  def change
    add_column :lists, :total_carbohydrates, :integer, :default => 0
    add_column :lists, :total_fat, :integer, :default => 0
    add_column :lists, :total_protein, :integer, :default => 0
    add_column :lists, :total_sugar, :integer, :default => 0
  end
end
