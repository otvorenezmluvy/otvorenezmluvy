class IndexEgovskDocumentDetailsOnDocumentId < ActiveRecord::Migration
  def change
    add_index :egovsk_document_details, :document_id
  end
end
