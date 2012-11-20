class CreateEventsView < ActiveRecord::Migration
  def up
    drop_table :events
    execute <<-SQL
      CREATE OR REPLACE VIEW events AS
        SELECT document_id, user_id, 'CommentEvent' AS type, id AS external_id, 'Comment' AS external_type, created_at, updated_at FROM comments
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
