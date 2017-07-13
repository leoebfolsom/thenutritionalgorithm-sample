class AddNotificationCategoriesToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :is_notification, :integer, :default => nil
    add_column :activities, :user_id_to_be_notified, :integer, :default => nil
  end
end
