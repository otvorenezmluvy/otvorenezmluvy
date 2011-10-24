class CleanAppendixConnections < ActiveRecord::Migration
  def change
    rename_column :crz_appendix_connections, :crz_contract_id, :document_id
    remove_foreign_key :crz_appendix_connections, :name => :crz_appendix_connections_document_id_fk

    add_foreign_key :crz_appendix_connections, :documents, :dependent => :delete
    add_foreign_key :attachments, :documents, :dependent => :delete
    add_foreign_key :pages, :attachments, :dependent => :delete
  end
end
