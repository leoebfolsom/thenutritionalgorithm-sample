class AddUpCandCatToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :root_cat_name, :text
    add_column :foods, :sub_cat_name, :text
  end
end
