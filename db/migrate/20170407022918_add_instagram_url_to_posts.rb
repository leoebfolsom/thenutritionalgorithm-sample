class AddInstagramUrlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :instagram_url, :string
  end
end
