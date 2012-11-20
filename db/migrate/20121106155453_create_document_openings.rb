class CreateDocumentOpenings < ActiveRecord::Migration
  def change
    create_table :document_openings do |t|
      t.belongs_to :document, null: false
      t.belongs_to :user, null: false

      t.datetime :created_at, null: false
    end
    add_index :document_openings, :document_id
    add_index :document_openings, :user_id
  end
end
