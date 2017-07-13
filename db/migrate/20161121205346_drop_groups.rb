class DropGroups < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? 'groups'
      drop_table :groups, force: :cascade
    end
    if ActiveRecord::Base.connection.table_exists? 'groupits'
      drop_table :groupits, force: :cascade
    end
  end
end
