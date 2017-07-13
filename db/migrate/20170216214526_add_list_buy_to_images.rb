class AddListBuyToImages < ActiveRecord::Migration
  def change
    add_reference :images, :list_buy, index: true, foreign_key: true
  end
end
