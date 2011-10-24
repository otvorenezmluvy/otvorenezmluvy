class AddFlagsToQuestions < ActiveRecord::Migration
  def change
    add_column(:questions,:in_contract, :boolean, :default => true)
    add_column(:questions,:in_appendix, :boolean, :default => true)
  end
end
