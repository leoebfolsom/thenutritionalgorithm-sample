class AddListIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :list_id, :integer, :default => nil
  end
end
