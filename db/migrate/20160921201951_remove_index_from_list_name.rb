class RemoveIndexFromListName < ActiveRecord::Migration
  def change
    remove_index :lists, :name
  end
end
