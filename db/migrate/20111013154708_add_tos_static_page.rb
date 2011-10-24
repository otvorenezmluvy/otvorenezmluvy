class AddTosStaticPage < ActiveRecord::Migration
  def up
    StaticPage.create!(:title => 'Podmienky používania', :content => '') { |s| s.slug = 'podmienky-pouzivania' }
  end

  def down
    StaticPage.find_by_slug('podmienky-pouzivania').destroy
  end
end
