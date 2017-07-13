class DropGroupColumns < ActiveRecord::Migration
  def change
    remove_column :lists, :hard_add_groupits
    remove_column :lists, :hard_delete_groups
    remove_column :quantities, :group_id
    remove_column :quantities, :groupit_id
    remove_column :users, :favorites_groups
    remove_column :users, :hard_delete_groups
  end
end
