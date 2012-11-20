# encoding: utf-8
class UpdateQuestionText < ActiveRecord::Migration
  def up
    q = Question.find_by_text("Jedná sa o krátkodobú zmluvu?")
    q.text = "Ide o jednorazovú, príp. o krátkodobú zmluvu (kratšia ako 1 rok)?"
    q.save!
  end

  def down
    q = Question.find_by_text("Ide o jednorazovú, príp. o krátkodobú zmluvu (kratšia ako 1 rok)?")
    q.text = "Jedná sa o krátkodobú zmluvu?"
    q.save!
  end
end
