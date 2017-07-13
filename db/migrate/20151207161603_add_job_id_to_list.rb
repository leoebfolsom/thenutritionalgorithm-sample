class AddJobIdToList < ActiveRecord::Migration
  def change
    add_column :lists, :job_id, :integer
    add_column :lists, :job_finished_at, :datetime
  end
end
