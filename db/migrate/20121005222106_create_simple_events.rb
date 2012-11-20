class CreateSimpleEvents < ActiveRecord::Migration
  def change
    create_table :simple_events do |t|
      t.belongs_to :document, null: false
      t.belongs_to :user
      t.string :type, null: false
      t.belongs_to :external, polymorphic: true

      t.datetime :created_at, null: false
    end
    add_index :simple_events, [:document_id, :created_at]
    add_index :simple_events, :user_id
  end
end
