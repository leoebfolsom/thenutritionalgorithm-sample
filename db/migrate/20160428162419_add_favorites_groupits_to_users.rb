class AddFavoritesGroupitsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favorites_groupits, :string, :default => ''
  end
end
