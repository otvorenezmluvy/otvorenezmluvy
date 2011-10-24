class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :regis_subjects do |t|
      t.integer :regis_id, :null => false
      t.integer :ico, :null => false
      t.string :name, :null => false
      t.string :address
      t.date :created_on
      t.date :dissolved_on
      t.string :district
      t.integer :legal_form_code
      t.string :legal_form_label
      t.integer :sk_nace_category_code
      t.string :sk_nace_category_label
      t.integer :okec_category_code
      t.string :okec_category_label
      t.integer :sector_code
      t.string :sector_label
      t.integer :ownership_category_code
      t.string :ownership_category_label
      t.integer :organisation_size_category_code
      t.string :organisation_size_category_label
    end

    add_index :regis_subjects, :regis_id, :unique => true
    add_index :regis_subjects, :ico, :unique => true
  end
end
