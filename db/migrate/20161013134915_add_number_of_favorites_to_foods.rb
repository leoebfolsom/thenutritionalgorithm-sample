class AddNumberOfFavoritesToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :number_of_favorites, :integer, :default => 0
  end
end
