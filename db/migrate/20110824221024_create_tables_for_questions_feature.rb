class CreateTablesForQuestionsFeature < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :text, :null => false
    end

    create_table :question_choices do |t|
      t.references :question, :null => false
      t.string :label, :null => false
      t.boolean :wants_detail
    end
    add_foreign_key :question_choices, :questions, :dependent => :delete

    create_table :question_answers do |t|
      t.references :question, :null => false
      t.references :question_choice, :null => false
      t.text :detail
      t.timestamps
      t.references :user
    end
    add_foreign_key :question_answers, :questions, :dependent => :delete
    add_foreign_key :question_answers, :question_choices, :dependent => :delete
    add_foreign_key :question_answers, :users, :dependent => :nullify
  end
end
