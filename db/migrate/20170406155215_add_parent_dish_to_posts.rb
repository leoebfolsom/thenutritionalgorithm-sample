class AddParentDishToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :parent_dish, :integer, :default => nil
  end
end
