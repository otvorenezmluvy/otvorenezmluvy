class AddAlwaysShowFlagToQuestion < ActiveRecord::Migration
  def up
    add_column :questions, :always_shown, :boolean, :null => false, :default => false
    Question.update_all({ :always_shown => true }, { :id => [2, 4, 6, 7, 9] })
  end

  def down
    remove_column :questions, :always_shown
  end
end
