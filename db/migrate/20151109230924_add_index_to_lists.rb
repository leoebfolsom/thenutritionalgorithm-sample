class AddIndexToLists < ActiveRecord::Migration
  def change
    add_reference :lists, :user, index: true, foreign_key: true
    add_index :lists, [:user_id, :created_at]
  end
  
end
