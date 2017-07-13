class AddHardAddGroupitsToLists < ActiveRecord::Migration
  def change
    add_column :lists, :hard_add_groupits, :string, :default => ''
  end
end
