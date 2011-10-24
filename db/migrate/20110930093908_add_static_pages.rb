class AddStaticPages < ActiveRecord::Migration
  def up
    StaticPage.create(:title => 'Ako môžem pomôcť?', :content => '') { |s| s.slug = 'ako-mozem-pomoct' }
    StaticPage.create(:title => 'FAQ', :content => '') { |s| s.slug = 'faq' }
    StaticPage.create(:title => 'O projekte', :content => '') { |s| s.slug = 'o-projekte' }
    StaticPage.create(:title => 'Kontakt', :content => '') { |s| s.slug = 'kontakt' }
    StaticPage.create(:title => 'Autorské práva', :content => '') { |s| s.slug = 'autorske-prava' }
  end

  def down
    StaticPage.delete_all
  end
end
