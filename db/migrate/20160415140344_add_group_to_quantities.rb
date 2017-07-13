class AddGroupToQuantities < ActiveRecord::Migration
  def change
    add_reference :quantities, :group, index: true, foreign_key: true
  end
end