class DropLikelists < ActiveRecord::Migration
  def change
    drop_table :likelists, force: :cascade
  end
end
