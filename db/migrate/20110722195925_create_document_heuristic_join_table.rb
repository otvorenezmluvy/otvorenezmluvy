class CreateDocumentHeuristicJoinTable < ActiveRecord::Migration
  def change
    create_table :documents_heuristics, :id => false do |t|
      t.references :document, :null => false
      t.references :heuristic, :null => false
    end
  end
end
