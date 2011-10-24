class CreateBannedIps < ActiveRecord::Migration
  def change
    create_table :banned_ips do |t|
      t.string :ip, :null => false
      t.timestamps
      t.integer :creator_id
    end
    add_foreign_key :banned_ips, :users, :column => :creator_id
    add_index :banned_ips, :ip, :unique => true
  end
end
