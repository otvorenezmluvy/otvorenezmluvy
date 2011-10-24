class AddNameToUser < ActiveRecord::Migration
  def up
    add_column :users, :name, :string
    User.update_all "name = email"
    change_column :users, :name, :string, :null => false
  end

  def down
    remove_column :users, :name
  end
end
