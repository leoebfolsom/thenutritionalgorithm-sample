class AddDefaultNilToInstagramColumnsPosts < ActiveRecord::Migration
  def change
    change_column_default :posts, :instagram_url, nil
    change_column_default :posts, :instagram_user, nil
    change_column_default :posts, :instagram_user_url, nil
  end
end
