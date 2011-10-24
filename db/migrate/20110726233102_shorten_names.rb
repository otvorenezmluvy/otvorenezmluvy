class ShortenNames < ActiveRecord::Migration
  def change
    rename_table :document_attachments, :attachments
    rename_table :attachment_pages, :pages
  end
end
