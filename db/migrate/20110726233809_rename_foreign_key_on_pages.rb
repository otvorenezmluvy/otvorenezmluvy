class RenameForeignKeyOnPages < ActiveRecord::Migration
  def change
    rename_column :pages, :document_attachment_id, :attachment_id
  end
end
