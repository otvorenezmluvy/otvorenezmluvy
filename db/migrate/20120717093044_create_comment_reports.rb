class CreateCommentReports < ActiveRecord::Migration
  def change
    create_table :comment_reports do |t|
      t.belongs_to :comment, null: false
      t.belongs_to :user
      t.text :body, null: false

      t.timestamps null: false
    end

    add_index :comment_reports, :comment_id
  end
end
