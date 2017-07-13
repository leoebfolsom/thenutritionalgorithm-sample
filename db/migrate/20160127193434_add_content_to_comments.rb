class AddContentToComments < ActiveRecord::Migration
  def change
    add_column :comments, :content, :text, :default => ""
  end
end
