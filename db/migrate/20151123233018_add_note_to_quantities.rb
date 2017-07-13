class AddNoteToQuantities < ActiveRecord::Migration
  def change
  	add_column :quantities, :note, :text, :default => ""
  end
end
