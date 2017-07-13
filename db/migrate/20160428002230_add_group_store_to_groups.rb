class AddGroupStoreToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :group_store, :string
  end
end
