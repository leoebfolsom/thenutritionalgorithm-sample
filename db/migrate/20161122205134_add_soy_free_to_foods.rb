class AddSoyFreeToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :soy_free, :integer, :default => 0
  end
end
