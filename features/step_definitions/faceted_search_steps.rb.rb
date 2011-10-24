When /^I restrict search using (.+) facet to "(.+)"$/ do |facet_name, value|
  page.should have_content(value)
  within("#facets .#{facet_name}") do
    click_link value
  end
end

When /^I remove "(.+)" restriction from (.+) facet$/ do |value, facet_name|
  page.should have_content(value)
  within("#facets .#{facet_name}") do
    click_link value
  end
end

Then /^I should see only documents with "(.+)" as supplier$/ do |query|
  page.all("#results li").each do |match|
    match.should have_content(query)
  end
end

When /^I should see only documents with "(.+)" in publication date$/ do |date|
  page.all("#results li .details").each do |match|
    match.should have_content(date)
  end
end

When /^I sort results by (.*)$/ do |field|
  within('#results .sort') do
    select(field)
  end
  click_button('Usporiadaj')
end

Then /^I should see matching documents sorted by (.*)$/ do |field|
  page.find_field("sort").value.should =~ /#{field}/
  page.should have_selector("#results li .#{field}")
  field_values = page.all("#results li .#{field}").collect(&:text)
  sorted = field_values.clone.sort.reverse
  field_values.should == sorted
end

When /^I remove all restrictions$/ do
  click_link "Zmazať všetky obmedzenia"
end

Then /^I should see no restrictions applied$/ do
  page.find(".total_hits").text.to_i.should == Document.count
end

Then /^I should see no matching documents found$/ do
  page.find(".total_hits").text.to_i.should == 0
end