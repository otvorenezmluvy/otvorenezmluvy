class AddReferenceToDocumentToQuestionAnswers < ActiveRecord::Migration
  def change
    add_column :question_answers, :document_id, :integer
    add_foreign_key :question_answers, :documents, :dependent => :delete
  end
end
