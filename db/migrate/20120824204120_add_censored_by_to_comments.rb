class AddCensoredByToComments < ActiveRecord::Migration
  def change
    add_column :comments, :censored_by_id, :integer
    add_foreign_key :comments, :users, column: :censored_by_id, dependent: :nullify
  end
end
