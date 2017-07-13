class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :total_calories
      t.integer :total_carbohydrates
      t.integer :total_fat
      t.integer :total_protein
      t.integer :total_sugar
      t.integer :total_potassium
      t.integer :total_fiber
      t.integer :total_vitamin_a
      t.integer :total_vitamin_c
      t.integer :total_calcium
      t.float :total_iron
      t.integer :total_sodium
      t.float :total_price
      t.integer :meat
      t.string :image, :default => ''

      t.timestamps null: false
    end
    add_index :groups, :name, unique: true
  end
end
