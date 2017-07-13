class AddStoreToLists < ActiveRecord::Migration
  def change
    add_column :lists, :store, :string
  end
end
