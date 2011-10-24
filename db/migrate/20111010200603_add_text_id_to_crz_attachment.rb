class AddTextIdToCrzAttachment < ActiveRecord::Migration
  def up
    add_column :crz_attachment_details, :crz_text_id, :integer
    add_column :crz_attachment_details, :note, :text
    change_column :crz_attachment_details, :crz_doc_id, :integer, :null => true
  end

  def down
    change_column :crz_attachment_details, :crz_doc_id, :integer, :null => false
    remove_column :crz_attachment_details, :note
    remove_column :crz_attachment_details, :crz_text_id
  end
end
