class AddEgovskModels < ActiveRecord::Migration
  def change
    create_table :egovsk_document_details do |t|
        t.integer :egovsk_id, :null => false
        t.decimal :total_amount, :precision => 12, :scale => 2
        t.string :customer, :null => false
        t.string :supplier, :null => false
        t.integer :supplier_ico
        t.text :note
        t.date :signed_on
        t.date :published_on
        t.date :effective_from
        t.date :valid_from
        t.date :expires_on
        t.string :contract_number
        t.string :root_contract_number
        t.string :contract_type
        t.string :periodicity
        t.references :document, :null => false
        t.timestamps :null => false
    end

    add_index :egovsk_document_details, :egovsk_id, :unique => true
    add_foreign_key :egovsk_document_details, :documents, :dependent => :delete

    create_table :egovsk_attachment_details do |t|
      t.references :attachment, :null => false
      t.integer :egovsk_doc_id, :null => false
      t.integer :egovsk_doc2_id, :null => false
    end

    add_foreign_key :egovsk_attachment_details, :attachments, :dependent => :delete

  end
end
