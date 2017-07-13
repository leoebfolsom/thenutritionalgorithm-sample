class AddHardAddToLists < ActiveRecord::Migration
  def change
    add_column :lists, :hard_add, :string, :default => ''
  end
end