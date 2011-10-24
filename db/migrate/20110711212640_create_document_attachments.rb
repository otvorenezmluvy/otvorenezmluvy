class CreateDocumentAttachments < ActiveRecord::Migration
  def change
    create_table :document_attachments do |t|
      t.belongs_to :document, :null => false
      t.integer :crz_doc_id, :null => false

      t.timestamps :null => false
    end
    add_index :document_attachments, :document_id
    add_index :document_attachments, :crz_doc_id, :unique => true
  end
end
