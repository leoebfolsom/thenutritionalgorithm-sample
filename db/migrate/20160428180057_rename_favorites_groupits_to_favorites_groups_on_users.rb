class RenameFavoritesGroupitsToFavoritesGroupsOnUsers < ActiveRecord::Migration
  def up
    rename_column :users, :favorites_groupits, :favorites_groups
  end

  def down
    rename_column :users, :favorites_groups, :favorites_groupits
  end
end
