class DropCustomAttributesFromQuantities < ActiveRecord::Migration
  def change
    remove_column :quantities, :custom_attributes
  end
end
