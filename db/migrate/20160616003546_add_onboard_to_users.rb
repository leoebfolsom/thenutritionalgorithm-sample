class AddOnboardToUsers < ActiveRecord::Migration
  def change
    add_column :users, :onboard, :string
  end
end
