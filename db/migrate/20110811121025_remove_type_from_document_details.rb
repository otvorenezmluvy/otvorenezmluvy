class RemoveTypeFromDocumentDetails < ActiveRecord::Migration
  def up
    remove_column :crz_document_details, :type
  end

  def down
    add_column :crz_document_details, :type, :string, :null => false
  end
end
