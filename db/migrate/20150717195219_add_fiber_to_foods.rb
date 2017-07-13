class AddFiberToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :fiber, :integer
  end
end
