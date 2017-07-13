class AddMeatToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :meat, :integer, :default => 0
  end
end