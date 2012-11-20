class AddIndexOnDocumentToCrzDocumentDetails < ActiveRecord::Migration
  def change
    add_index :crz_document_details, :document_id
  end
end
