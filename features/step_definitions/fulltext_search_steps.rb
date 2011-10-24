When /^I search for "(.+)"$/ do |query|
  fill_in 'q', :with => query
  click_button 'Hladať'
end

Then /^I should see ([0-9]+) matching document[s]*$/ do |count|
  page.should have_content("v #{count} zmluv")
end

When /^I should see "(.+)" highlighted on ([0-9]+) pages$/ do |query, count|
  match_pages = page.all("#results li li")
  match_pages.count.should == count.to_i
  page.all("#results li em").each do |page|
    page.should have_content(query)
  end
end

When /^I open a matching document$/ do
  page.find("#results li a:first").click
end