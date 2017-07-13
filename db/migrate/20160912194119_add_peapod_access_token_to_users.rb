class AddPeapodAccessTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :peapod_access_token, :string
  end
end
