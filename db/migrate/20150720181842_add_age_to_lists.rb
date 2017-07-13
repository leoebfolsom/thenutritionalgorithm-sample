class AddAgeToLists < ActiveRecord::Migration
  def change
    add_column :lists, :age, :integer
  end
end
