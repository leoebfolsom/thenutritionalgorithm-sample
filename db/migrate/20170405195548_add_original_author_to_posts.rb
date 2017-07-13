class AddOriginalAuthorToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :original_author, :integer, :default => nil
  end
end
