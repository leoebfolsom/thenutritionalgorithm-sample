class AddListBuyCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :list_buy_code, :string
  end
end