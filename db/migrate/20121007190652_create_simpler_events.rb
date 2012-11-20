class CreateSimplerEvents < ActiveRecord::Migration
  def up
    drop_table :simple_events
    create_table :events do |t|
      t.belongs_to :for_user, null: false
      t.belongs_to :external, polymorphic: true
      t.string :type, null: false
      t.timestamps
    end

    add_index :events, [:for_user_id, :created_at]
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
