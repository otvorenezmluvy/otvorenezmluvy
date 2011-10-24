class AddGuestFlagToUser < ActiveRecord::Migration
  def change
    add_column :users, :guest, :boolean, :null => false, :default => false
    User.update_all("guest = true", "email LIKE 'guest_%'")
  end
end
