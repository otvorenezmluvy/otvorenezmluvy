When /^I save search as heuristic "(.+)" with (.+) point(?:|s) and explanation "(.+)"$/ do |name, points, explanation|
  within("#new_heuristic") do
    fill_in "Názov heuristiky", :with => name
    fill_in "Počet bodov", :with => points
    fill_in "Vysvetlenie", :with => explanation
    click_button "Vytvoriť heuristiku"
  end
end

When /^I update heuristic to "(.+)", (\d+) points and explanation "(.+)"$/  do |name, points, explanation|
  within(".edit_heuristic") do
    fill_in "Názov heuristiky", :with => name
    fill_in "Počet bodov", :with => points
    fill_in "Vysvetlenie", :with => explanation
    click_button "Upraviť heuristiku"
  end
end

Then /^I should see (\d+) document(?:|s) with (\d+) points$/ do |total_results, points|
  page.all("#results li").size.should == total_results.to_i
  page.all("#results li").each do |result|
    result.should have_content(points)
  end
end

Then /^I should see a filled form for heuristic "(.+)", (\d+) points and "(.+)" as explanation$/ do |name, points, explanation|
  page.find_field("Názov heuristiky").value.should == name
  page.find_field("Počet bodov").value.should == points
  page.find_field("Vysvetlenie").value.should == explanation
end

When /^I delete heuristic$/ do
  click_link "Zmazať heuristiku"
end

Then /^I should see an empty form for heuristic$/ do
  page.should have_selector("#new_heuristic")
end

When /^I list defined heuristics$/ do
  click_link "Zoznam heuristík"
end

When /^I should see a defined heuristic "(.+)" with (\d+) points and explanation "(.+)"$/ do |name, points, explanation|
  page.find("#heuristics tbody").should have_content(name)
  page.all("#heuristics tbody tr").each do |row|
    cells = row.all("td").to_a
    next unless cells[0].text == name
    cells[1].should have_content(explanation)
    cells[2].should have_content(points)
  end
end