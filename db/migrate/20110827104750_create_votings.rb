class CreateVotings < ActiveRecord::Migration
  def change
    create_table :votings do |t|
      t.references :user, :null => false
      t.references :comment, :null => false
      t.string :up_or_down, :null => false
    end

    add_index :votings, [:user_id, :comment_id]
  end

end
