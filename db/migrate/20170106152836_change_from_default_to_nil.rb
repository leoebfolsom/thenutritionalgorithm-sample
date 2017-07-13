class ChangeFromDefaultToNil < ActiveRecord::Migration
  def change
    change_column :activities, :from, :string, :default => nil
  end
end
