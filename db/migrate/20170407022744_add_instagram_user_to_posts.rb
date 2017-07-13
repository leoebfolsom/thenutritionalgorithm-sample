class AddInstagramUserToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :instagram_user, :string
    add_column :posts, :instagram_user_url, :string
  end
end
