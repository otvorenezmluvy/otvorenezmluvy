Then /^I should see quicksearch results for "(.+)"$/ do |query|
  page.find("#quicksearch #q").value.should == query
  page.all("#quickresults li").size.should_not == 0
end