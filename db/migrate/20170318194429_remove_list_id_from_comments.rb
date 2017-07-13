class RemoveListIdFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :list_id
  end
end
