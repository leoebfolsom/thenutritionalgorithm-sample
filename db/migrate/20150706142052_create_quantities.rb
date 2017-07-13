class CreateQuantities < ActiveRecord::Migration
  def change
    create_table :quantities do |t|
      t.references :food, index: true, foreign_key: true
      t.references :list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
