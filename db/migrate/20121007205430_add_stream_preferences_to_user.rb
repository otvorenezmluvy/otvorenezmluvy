class AddStreamPreferencesToUser < ActiveRecord::Migration
  def change
    add_column :users, :stream_show_openings, :boolean, null: false, default: true
    add_column :users, :stream_show_watching, :boolean, null: false, default: true
    add_column :users, :stream_show_my_comments, :boolean, null: false, default: true
    add_column :users, :stream_show_other_comments, :boolean, null: false, default: true
    add_column :users, :stream_show_answers, :boolean, null: false, default: true
  end
end
