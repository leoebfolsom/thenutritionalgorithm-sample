class AddForkedListIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :forked_list_id, :integer, :default => nil
  end
end
