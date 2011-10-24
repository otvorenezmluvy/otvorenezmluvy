class AddStatusToDetail < ActiveRecord::Migration
  def change
    add_column :crz_document_details, :status, :string
  end
end
