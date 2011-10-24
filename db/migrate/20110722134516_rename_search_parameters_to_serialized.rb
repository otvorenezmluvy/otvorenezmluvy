class RenameSearchParametersToSerialized < ActiveRecord::Migration
  def change
    rename_column :heuristics, :search_parameters, :serialized_search_parameters
  end
end
