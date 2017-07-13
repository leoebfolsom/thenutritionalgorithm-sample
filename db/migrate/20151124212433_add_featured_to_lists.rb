class AddFeaturedToLists < ActiveRecord::Migration
  def change
  	add_column :lists, :featured, :integer, :default => 0
  end
end
