class RemoveNameFromDetail < ActiveRecord::Migration
  def up
    remove_column :crz_document_details, :name
  end

  def down
    add_column :crz_document_details, :name, :string
  end
end
