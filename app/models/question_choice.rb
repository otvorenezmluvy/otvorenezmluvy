class QuestionChoice < ActiveRecord::Base
  belongs_to :question
  has_many :question_answer
end