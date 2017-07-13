class ChangeAttributesUpdatedToString < ActiveRecord::Migration
  def change
    change_column :activities, :attribute_updated, :string
  end
end
