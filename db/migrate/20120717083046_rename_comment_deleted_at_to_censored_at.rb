class RenameCommentDeletedAtToCensoredAt < ActiveRecord::Migration
  def change
    rename_column :comments, :deleted_at, :censored_at
  end
end
