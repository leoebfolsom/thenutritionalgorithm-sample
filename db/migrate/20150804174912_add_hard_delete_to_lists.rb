class AddHardDeleteToLists < ActiveRecord::Migration
  def change
    add_column :lists, :hard_delete, :string, :default => ''
  end
end
