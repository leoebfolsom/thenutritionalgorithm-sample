class AddUserToFoods < ActiveRecord::Migration
  def change
    add_reference :foods, :user, index: true, foreign_key: true
  end
end
