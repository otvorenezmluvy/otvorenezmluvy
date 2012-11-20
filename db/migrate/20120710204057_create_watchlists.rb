class CreateWatchlists < ActiveRecord::Migration
  def change
    create_table :watchlists do |t|
      t.references :user, :null => false
      t.references :document, :null => false
      t.string :notice
      t.timestamps
    end

    add_index :watchlists, [:user_id, :document_id]
  end
end
