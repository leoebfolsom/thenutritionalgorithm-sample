class AddGenderToLists < ActiveRecord::Migration
  def change
    add_column :lists, :gender, :char
  end
end
