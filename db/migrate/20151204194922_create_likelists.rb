class CreateLikelists < ActiveRecord::Migration
  def change
    create_table :likelists do |t|
    	t.integer :user_id
    	t.integer :list_id

    	t.timestamps null: false
    end

    add_index :likelists, :user_id
    add_index :likelists, :list_id
    add_index :likelists, [:user_id, :list_id], unique: true
  end
end