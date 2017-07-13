class AddSeenToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :seen, :integer, :default => nil
  end
end
