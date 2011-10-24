class CreateAttachmentPages < ActiveRecord::Migration
  def change
    create_table :attachment_pages do |t|
      t.references :document_attachment, :null => false
      t.integer :number, :null => false
      t.text :contents
      t.timestamps :null => false
    end
    add_index :attachment_pages, :document_attachment_id
  end
end
