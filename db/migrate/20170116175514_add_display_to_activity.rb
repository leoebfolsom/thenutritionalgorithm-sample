class AddDisplayToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :display, :integer, :default => 1
  end
end
