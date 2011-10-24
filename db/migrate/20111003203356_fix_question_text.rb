class FixQuestionText < ActiveRecord::Migration
  def up
    q = Question.find_by_text("Definuje dokument vo svojej zverejnenej podobe jasné, čo je jeho predmetom (za čo presne sa platilo)?")
    unless q.nil?
      q.text = "Definuje dokument vo svojej zverejnenej podobe, čo je jeho predmetom (za čo presne sa platilo)?"
      q.save
    end
  end

  def down
  end
end
