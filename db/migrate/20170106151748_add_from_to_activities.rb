class AddFromToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :from, :string, :default => ""
  end
end
