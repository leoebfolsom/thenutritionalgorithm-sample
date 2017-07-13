class RenameFromToArrivedFrom < ActiveRecord::Migration
  def change
    rename_column :activities, :from, :arrived_from
  end
end
