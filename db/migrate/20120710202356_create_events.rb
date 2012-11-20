class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :document, :null => false
      t.references :user, :null => false
      t.string :change_type, :null => false
      t.integer :external_id
      t.string :external_type
      t.timestamps
    end

    add_index :events, :document_id
  end
end
