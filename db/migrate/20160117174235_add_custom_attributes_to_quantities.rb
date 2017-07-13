class AddCustomAttributesToQuantities < ActiveRecord::Migration
  def change
    add_column :quantities, :custom_attributes, :json, default: '[]'
  end
end
