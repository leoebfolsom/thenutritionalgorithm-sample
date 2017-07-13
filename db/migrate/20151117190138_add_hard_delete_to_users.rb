class AddHardDeleteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hard_delete, :string, :default => ''
  end
end
