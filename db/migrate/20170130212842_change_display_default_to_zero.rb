class ChangeDisplayDefaultToZero < ActiveRecord::Migration
  def change
    change_column :activities, :display, :integer, :default => 0
  end
end
