class AddCommentIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :comment_id, :integer, :default => nil
  end
end