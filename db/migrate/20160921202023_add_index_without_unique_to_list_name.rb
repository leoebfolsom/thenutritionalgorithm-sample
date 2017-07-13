class AddIndexWithoutUniqueToListName < ActiveRecord::Migration
  def change
    add_index :lists, :name
  end
end
