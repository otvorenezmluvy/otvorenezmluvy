class AddQuestions < ActiveRecord::Migration
  def up
    q = Question.new(:text => "Je zmluva zle oskenovaná/nečitateľná?")
    q.question_choices.build(:label => "áno")
    q.question_choices.build(:label => "nie")
    q.save

    q = Question.new(:text => "Sú v zmluve vyčiernené podstatné údaje?")
    q.question_choices.build(:label => "áno")
    q.question_choices.build(:label => "nie")
    q.save

    q = Question.new(:text => "Jedná sa o krátkodobú zmluvu?")
    q.question_choices.build(:label => "áno")
    q.question_choices.build(:label => "nie")
    q.save

    q = Question.find_by_text("Je zmluva vypovedateľná aj inak ako \"po vzájomnej dohode oboch strán\"?")
    q.question_choices.build(:label => "zmluva to neuvádza")
    q.save
  end

  def down
  end
end
