class AddNoteToLists < ActiveRecord::Migration
  def change
  	add_column :lists, :note, :text, :default => ""
  end
end
