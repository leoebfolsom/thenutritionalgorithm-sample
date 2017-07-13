class AddIpToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :ip, :string, :default => ""
  end
end
