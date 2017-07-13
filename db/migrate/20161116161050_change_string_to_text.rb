class ChangeStringToText < ActiveRecord::Migration
  def change
    change_column :users, :hard_delete, :text
    change_column :users, :favorites, :text    
    change_column :lists, :hard_delete, :text
    change_column :lists, :hard_add, :text
  end
end
