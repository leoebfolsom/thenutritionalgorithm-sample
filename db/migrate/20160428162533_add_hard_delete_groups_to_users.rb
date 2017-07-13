class AddHardDeleteGroupsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hard_delete_groups, :string, :default => ''
  end
end
