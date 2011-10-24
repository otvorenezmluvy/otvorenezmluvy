class AddKodexToStaticPage < ActiveRecord::Migration
  def up
    StaticPage.create!(:title => 'Kódex diskutujúceho', :content => '') { |s| s.slug = 'kodex-diskutujuceho' }
  end

  def down
    StaticPage.find_by_slug('kodex-diskutujuceho').destroy
  end
end
