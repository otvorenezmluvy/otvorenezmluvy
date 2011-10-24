class AddPlaceInfoToEgovskDocumentDetail < ActiveRecord::Migration
  def change
    add_column :egovsk_document_details, :customer_id, :integer
    add_column :egovsk_document_details, :founder, :string
    add_index :egovsk_document_details, :customer_id
    add_column :egovsk_attachment_details, :egovsk_attachment_type, :string
  end
end
