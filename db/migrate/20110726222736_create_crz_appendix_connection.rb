class CreateCrzAppendixConnection < ActiveRecord::Migration
  def change
    create_table :crz_appendix_connections do |t|
      t.references :document, :null => false
      t.integer :crz_id, :null => false
    end
    add_index :crz_appendix_connections, :document_id
    add_foreign_key :crz_appendix_connections, :documents, :column => :document_id, :dependent => :nullify
  end
end

