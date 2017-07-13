class AddSocialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instagram, :string, :default => ""
    add_column :users, :website, :string, :default => ""
    add_column :users, :twitter, :string, :default => ""
  end
end
