class AddReportsCountToComments < ActiveRecord::Migration
  def change
    add_column :comments, :reports_count, :integer, null: false, default: 0
  end
end
