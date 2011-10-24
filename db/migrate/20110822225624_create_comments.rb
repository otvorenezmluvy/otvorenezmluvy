class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment
      t.text :area
      t.references :page

      t.timestamps
    end
    add_index :comments, :page_id
  end
end
