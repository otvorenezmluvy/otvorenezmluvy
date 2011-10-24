class IndexHeuristicsByFingerprint < ActiveRecord::Migration
  def change
    add_index :heuristics, :serialized_search_parameters, :unique => true
  end
end
