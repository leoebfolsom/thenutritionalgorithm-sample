class AddGroupitToQuantities < ActiveRecord::Migration
  def change
    add_reference :quantities, :groupit, index: true, foreign_key: true
  end
end
