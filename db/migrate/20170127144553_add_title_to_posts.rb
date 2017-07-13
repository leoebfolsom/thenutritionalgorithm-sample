class AddTitleToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :title, :string, :default => ''
  end
end
