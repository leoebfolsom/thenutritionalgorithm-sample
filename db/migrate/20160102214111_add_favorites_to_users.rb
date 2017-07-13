class AddFavoritesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favorites, :string, :default => ''
  end
end
