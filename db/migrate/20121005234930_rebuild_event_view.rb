class RebuildEventView < ActiveRecord::Migration
  def up
    add_column :simple_events, :updated_at, :datetime, null: false
    execute 'DROP VIEW events'
    execute <<-SQL
      CREATE OR REPLACE VIEW events AS
        SELECT document_id, user_id, 'CommentEvent'::varchar AS type, id AS external_id, 'Comment'::varchar AS external_type, created_at, updated_at FROM comments
        UNION ALL
        SELECT document_id, user_id, 'QuestionAnswerEvent'::varchar AS type, id AS external_id, 'QuestionAnswer'::varchar AS external_type, created_at, updated_at FROM question_answers
        UNION ALL
        SELECT document_id, user_id, type, external_id, external_type, created_at, updated_at FROM simple_events
    SQL
  end

  def down
  end
end
