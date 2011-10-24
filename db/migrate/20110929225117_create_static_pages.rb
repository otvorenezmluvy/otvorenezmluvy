class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :slug, :null => false, :limit => 100, :uniq => true
      t.string :title, :null => false, :limit => 100
      t.text :content, :null => false

      t.timestamps
    end

    add_index :static_pages, :slug
  end
end
