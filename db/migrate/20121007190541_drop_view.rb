class DropView < ActiveRecord::Migration
  def up
    execute 'DROP VIEW events'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
