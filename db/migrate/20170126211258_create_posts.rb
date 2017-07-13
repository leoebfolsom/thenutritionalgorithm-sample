class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|

      t.text :body, :default => ""
      t.references :list, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    
    end
  end
end
