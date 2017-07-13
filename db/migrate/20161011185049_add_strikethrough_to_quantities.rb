class AddStrikethroughToQuantities < ActiveRecord::Migration
  def change
    add_column :quantities, :strikethrough, :integer, :default => 0
  end
end
