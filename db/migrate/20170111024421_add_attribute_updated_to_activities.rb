class AddAttributeUpdatedToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :attribute_updated, :integer, :default => nil
  end
end
