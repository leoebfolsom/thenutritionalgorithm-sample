class AddViewedUserIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :viewed_user_id, :integer, :default => nil
  end
end
