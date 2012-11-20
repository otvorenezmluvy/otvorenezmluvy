class AddResultsPerPageToUser < ActiveRecord::Migration
  def change
    add_column :users, :results_per_page, :integer, null: false, default: 15
  end
end
