class RenameDocumentIdToContractId < ActiveRecord::Migration
  def change
    rename_column :crz_appendix_connections, :document_id, :crz_contract_id
  end
end
