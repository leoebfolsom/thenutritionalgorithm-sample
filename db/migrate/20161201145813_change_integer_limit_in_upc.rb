class ChangeIntegerLimitInUpc < ActiveRecord::Migration
  def change
    change_column :foods, :food_store_id, :integer, limit: 8
  end
end
