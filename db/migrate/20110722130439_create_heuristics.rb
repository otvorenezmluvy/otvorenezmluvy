class CreateHeuristics < ActiveRecord::Migration
  def change
    create_table :heuristics do |t|
      t.string :name, :null => false
      t.text :explanation, :null => false
      t.integer :points, :null => false
      t.text :search_parameters, :null => false

      t.timestamps :null => false
    end
  end
end
