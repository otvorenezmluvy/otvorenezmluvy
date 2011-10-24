class ChangeQuestionTexts < ActiveRecord::Migration
  def up
    q = Question.find_by_text("Ak zmluva obsahuje odkaz na nejaké prílohy, sú všetky tieto prílohy zverejnené spolu so zmluvou?")
    unless q.nil?
      q.in_appendix = false
      q.save
    end

    q = Question.find_by_text("Definuje zmluva vo svojej zverejnenej podobe jasné, čo je jej predmetom (za čo presne sa platilo)?")
    unless q.nil?
      q.text = "Definuje dokument vo svojej zverejnenej podobe jasné, čo je jeho predmetom (za čo presne sa platilo)?"
      q.save
    end

    q = Question.find_by_text("Je v zmluve (v jej zverejnenej podobe) jasne definovaná cena?")
    unless q.nil?
      q.text = "Je v dokumente jasne definovaná cena (ak ma byť uvedená)?"
      q.save
    end

    q = Question.find_by_text("Je zrejmé koľko presne bude stáť celá zákazka?")
    unless q.nil?
      q.in_appendix = false
      q.save
    end

    q = Question.find_by_text("Je zmluva vypovedateľná aj inak ako \"po vzájomnej dohode oboch strán\"?")
    unless q.nil?
      q.in_appendix = false
      q.save
    end

    q = Question.find_by_text("Ak poznáte oblasť, ktorej sa zmluva týka - zdá sa vám cena predražená?")
    unless q.nil?
      q.text = "Ak poznáte oblasť, ktorej sa dokument týka - zdá sa vám cena predražená?"
      q.save
    end

    q = Question.find_by_text("Vidíte v zmluve iný zásadný problém? (Ak áno, opíšte ho pár slovami)")
    unless q.nil?
      q.text = "Vidíte v dokumente iný zásadný problém? (Ak áno, opíšte ho pár slovami)"
      q.save
    end

    q = Question.find_by_text("Je zmluva zle oskenovaná/nečitateľná?")
    unless q.nil?
      q.text = "Je dokument zle oskenovaný/nečitateľný?"
      q.save
    end

    q = Question.find_by_text("Sú v zmluve vyčiernené podstatné údaje?")
    unless q.nil?
      q.text = "Sú v dokumente vyčiernené podstatné údaje?"
      q.save
    end

    q = Question.find_by_text("Jedná sa o krátkodobú zmluvu?")
    unless q.nil?
      q.in_appendix = false
      q.save
    end
  end

  def down
  end
end
