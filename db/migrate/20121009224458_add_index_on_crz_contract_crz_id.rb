class AddIndexOnCrzContractCrzId < ActiveRecord::Migration
  def up
    add_index :crz_document_details, :contract_crz_id
  end

  def down
    remove_index :crz_document_details, :contract_crz_id
  end
end
