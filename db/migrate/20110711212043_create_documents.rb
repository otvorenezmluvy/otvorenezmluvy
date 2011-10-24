class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :crz_id, :null => false
      t.string :identifier, :null => false
      t.string :name, :null => false
      t.string :department
      t.string :customer, :null => false
      t.string :supplier, :null => false
      t.integer :supplier_ico
      t.decimal :contracted_amount, :precision => 12, :scale => 2
      t.decimal :total_amount, :precision => 12, :scale => 2
      t.text :note
      t.date :published_on
      t.date :effective_from
      t.date :expires_on
      t.integer :contract_crz_id
      t.string :type, :null => false
      t.timestamps :null => false
    end

    add_index :documents, :crz_id, :unique => true
  end
end
