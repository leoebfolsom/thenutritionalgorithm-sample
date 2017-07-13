class AddPercentageToLists < ActiveRecord::Migration
  def change
    add_column :lists, :percentage, :integer, :default => nil
  end
end
