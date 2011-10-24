class Question < ActiveRecord::Base
  has_many :question_choices
  has_many :question_answers

  scope :for_contract, where(:in_contract => true).includes(:question_choices)
  scope :for_appendix, where(:in_appendix => true).includes(:question_choices)
end
