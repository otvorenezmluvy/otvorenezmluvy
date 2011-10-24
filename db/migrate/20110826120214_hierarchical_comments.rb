class HierarchicalComments < ActiveRecord::Migration
  def up
    add_column :comments, :parent_id, :integer
    add_column :comments, :votes, :integer, :null => false, :default => 0
    change_column :comments, :document_id, :integer, :null => true

    add_index :comments, :parent_id
  end

  def down
    change_column :comments, :document_id, :integer, :null => false
    remove_column :comments, :votes
    remove_column :comments, :parent_id

    remove_index :comments, :parent_id
  end
end
