class AddRestrictionsToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :dairy_free, :integer, :default => 0
    add_column :foods, :peanut_free, :integer, :default => 0
    add_column :foods, :gluten_free, :integer, :default => 0
    add_column :foods, :egg_free, :integer, :default => 0
    add_column :foods, :kosher, :integer, :default => 0
    add_column :foods, :store_brand, :integer, :default => 0
    add_column :foods, :organic, :integer, :default => 0
  end
end
