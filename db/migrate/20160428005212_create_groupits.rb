class CreateGroupits < ActiveRecord::Migration
  def change
    create_table :groupits do |t|
      t.integer :amount
      t.references :group, index: true, foreign_key: true
      t.references :list, index: true, foreign_key: true
      t.json :custom_attributes, default: '[]'

      t.timestamps null: false
    end
  end
end
