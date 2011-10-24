class RenamePageContentsToText < ActiveRecord::Migration
  def change
    rename_column :attachment_pages, :contents, :text
  end
end
