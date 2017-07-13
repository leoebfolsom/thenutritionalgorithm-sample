class AddHealthyToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :healthy, :integer, :default => 1
  end
end
