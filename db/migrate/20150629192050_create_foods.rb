class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name
      t.integer :calories
      t.integer :carbohydrates
      t.integer :fat
      t.integer :protein
      t.integer :sugar
      
      t.timestamps null: false
    end
  end
end
