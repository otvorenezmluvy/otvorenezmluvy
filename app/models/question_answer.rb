class QuestionAnswer < ActiveRecord::Base
  belongs_to :question
  belongs_to :question_choice
  belongs_to :user
  belongs_to :document
end