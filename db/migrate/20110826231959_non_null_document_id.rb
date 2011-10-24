class NonNullDocumentId < ActiveRecord::Migration
  def up
    change_column :comments, :document_id, :integer, :null => false
  end

  def down
    change_column :comments, :document_id, :integer, :null => true
  end
end
