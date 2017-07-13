class CreateListBuys < ActiveRecord::Migration
  def change
    create_table :list_buys do |t|
      t.string :receipt_image
      t.float :total_price
      t.integer :total_calories
      t.integer :total_carbohydrates
      t.integer :total_fat
      t.integer :total_protein
      t.integer :total_fiber
      t.integer :total_vitamin_a
      t.integer :total_vitamin_c
      t.float :total_iron
      t.integer :total_calcium
      t.integer :total_sodium
      t.integer :total_sugar
      t.references :list, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
