class AddUnprocessedToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :unprocessed, :integer, :default => 0
  end
end
