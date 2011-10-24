class CreateAttachmentsSti < ActiveRecord::Migration
  def change
    add_column :document_attachments, :type, :string
    change_column :document_attachments, :type, :string, :null => false
  end
end
