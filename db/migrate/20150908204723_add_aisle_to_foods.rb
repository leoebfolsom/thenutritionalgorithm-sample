class AddAisleToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :aisle, :string, :default => ''
  end
end
