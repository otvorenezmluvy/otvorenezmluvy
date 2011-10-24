class AddFormulasToHeuristics < ActiveRecord::Migration
  def up
    rename_column :heuristics, :points, :formula
    change_column :heuristics, :formula, :string, :null => false
  end

  def down
    execute <<-SQL
      ALTER TABLE heuristics ALTER COLUMN formula TYPE integer USING CAST(formula AS INTEGER)
    SQL
    rename_column :heuristics, :formula, :points
  end
end
