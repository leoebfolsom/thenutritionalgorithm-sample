class AddImageToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :image, :string, :default => ''
  end
end
