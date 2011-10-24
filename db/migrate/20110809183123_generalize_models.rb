class GeneralizeModels < ActiveRecord::Migration
  def up
    Document.delete_all
    Attachment.delete_all
    Page.delete_all
    execute("TRUNCATE documents_heuristics")

    rename_table :documents, :crz_document_details
    add_column :crz_document_details, :document_id, :integer, :null => false

    create_table :documents do |t|
      t.string :name
      t.string :type, :null => false
      t.timestamps :null => false
    end

    add_foreign_key :crz_document_details, :documents, :dependent => :delete

    create_table :crz_attachment_details do |t|
      t.references :attachment, :null => false
      t.integer :crz_doc_id, :null => false
    end

    add_index :crz_attachment_details, :crz_doc_id, :unique => true
    add_foreign_key :crz_attachment_details, :attachments, :dependent => :delete

    remove_column :attachments, :crz_doc_id
    add_column :attachments, :name, :string
    add_column :attachments, :number, :integer, :null => false

    add_foreign_key :documents_heuristics, :documents, :dependent => :delete
    add_foreign_key :documents_heuristics, :heuristics, :dependent => :delete
    add_index :documents_heuristics, :document_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration # life is too short
  end
end
