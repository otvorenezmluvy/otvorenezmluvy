class AddAttachmentBaseNames < ActiveRecord::Migration
  def up
    add_column :crz_attachment_details, :base_text_name, :string, :limit => 50
    add_column :crz_attachment_details, :base_image_name, :string, :limit => 50
    execute <<-SQL
      UPDATE crz_attachment_details
         SET base_text_name = crz_doc_id || '-text',
             base_image_name = crz_doc_id;
    SQL
  end

  def down
    remove_column :crz_attachment_details, :base_image_name
    remove_column :crz_attachment_details, :base_text_name
  end
end
