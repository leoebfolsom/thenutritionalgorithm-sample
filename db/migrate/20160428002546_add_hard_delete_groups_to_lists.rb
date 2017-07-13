class AddHardDeleteGroupsToLists < ActiveRecord::Migration
  def change
    add_column :lists, :hard_delete_groups, :string, :default => ''
  end
end
