class CommentBelongsToDocument < ActiveRecord::Migration
  def up
    add_column :comments, :document_id, :integer, :null => false
  end

  def down
    remove_column :comments, :document_id
  end
end
