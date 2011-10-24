class CreateProcurements < ActiveRecord::Migration
  def change
    create_table :procurements do |t|
      t.integer :procurement_id
      t.string :bulletin_number
      t.float :price
      t.text :procurement_label
      t.string :procurer_name
      t.integer :procurer_ico
      t.string :procurer_address
      t.string :supplier_name
      t.integer :supplier_ico
      t.string :supplier_address
      t.date :published_on
    end

    create_table :temp_procurements do |t|
      t.string :vestnik_cislo
      t.string :zmluva_hodnota
      t.text :zakazka_nazov
      t.string :procurer_name
      t.string :procurer_ico
      t.string :procurer_address
      t.string :supplier_name
      t.string :supplier_ico
      t.string :supplier_address
      t.string :date_id
      t.string :source_url
    end
    
    #change_column :procurements, :price, :bigint
    add_index :procurements, :procurement_id
    add_index :procurements, :supplier_ico
    add_index :procurements, :procurer_ico
    add_index :procurements, :published_on
  end
end


