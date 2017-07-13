class AddPrivateNoteToLists < ActiveRecord::Migration
  def change
  	add_column :lists, :private_note, :text, :default => ""
  end
end
