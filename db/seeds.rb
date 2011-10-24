# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

q = Question.new(:text => "Ak zmluva obsahuje odkaz na nejaké prílohy, sú všetky tieto prílohy zverejnené spolu so zmluvou?")
q.in_appendix = false
q.question_choices.build(:label => "áno")
q.question_choices.build(:label => "nie")
q.question_choices.build(:label => "neviem posúdiť")
q.save

q = Question.new(:text => "Definuje dokument vo svojej zverejnenej podobe, čo je jeho predmetom (za čo presne sa platilo)?")
q.in_appendix = true
q.question_choices.build(:label => "áno")
q.question_choices.build(:label => "nie celkom")
q.question_choices.build(:label => "nie")
q.question_choices.build(:label => "neviem posúdiť")
q.save


q = Question.new(:text => "Je v dokumente jasne definovaná cena (ak ma byť uvedená)?")
q.question_choices.build(:label => "áno")
q.question_choices.build(:label => "uvedené sú iba jednotkové ceny")
q.question_choices.build(:label => "nie")
q.question_choices.build(:label => "neviem posúdiť")
q.save

q = Question.new(:text => "Je zrejmé koľko presne bude stáť celá zákazka?")
q.in_appendix = false
q.question_choices.build(:label => "áno")
q.question_choices.build(:label => "je uvedený iba maximálny limit")
q.question_choices.build(:label => "nie")
q.question_choices.build(:label => "neviem posúdiť")
q.save

q = Question.new(:text => "Je zmluva vypovedateľná aj inak ako \"po vzájomnej dohode oboch strán\"?")
q.in_appendix = false
q.question_choices.build(:label => "ľahko")
q.question_choices.build(:label => "ťažko")
q.question_choices.build(:label => "vôbec")
q.question_choices.build(:label => "neviem posúdiť")
q.question_choices.build(:label => "zmluva to neuvádza")
q.save

q = Question.new(:text => "Ak poznáte oblasť, ktorej sa dokument týka - zdá sa vám cena predražená?")
q.question_choices.build(:label => "veľmi predražená")
q.question_choices.build(:label => "predražená")
q.question_choices.build(:label => "nie")
q.question_choices.build(:label => "neviem posúdiť")
q.save

q = Question.new(:text => "Vidíte v dokumente iný zásadný problém? (Ak áno, opíšte ho pár slovami)")
q.question_choices.build(:label => "veľmi zásadný", :wants_detail => true)
q.question_choices.build(:label => "zásadný", :wants_detail => true)
q.question_choices.build(:label => "nie")
q.save

q = Question.new(:text => "Je dokument zle oskenovaný/nečitateľný?")
q.question_choices.build(:label => "áno")
q.question_choices.build(:label => "nie")
q.save

q = Question.new(:text => "Sú v dokumente vyčiernené podstatné údaje?")
q.question_choices.build(:label => "áno")
q.question_choices.build(:label => "nie")
q.save

q = Question.new(:text => "Jedná sa o krátkodobú zmluvu?")
q.in_appendix = false
q.question_choices.build(:label => "áno")
q.question_choices.build(:label => "nie")
q.save
