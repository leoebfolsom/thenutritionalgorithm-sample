class AddPeapodJsessionidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :peapod_jsessionid, :string
  end
end
