class AddImageIdAndPostIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :image_id, :integer, :default => nil
    add_column :activities, :post_id, :integer, :default => nil
  end
end
