Given /^I am not logged in$/ do
  Given %{I log out}
end

Given /^I log out$/ do
  visit destroy_user_session_path
end

Given /^no user with email "([^"]*)" exists$/ do |email|
  User.find_by_email(email).should be_nil
end

When /^I login as "([^"]*)" with password "([^"]*)"$/ do |email, password|
  visit new_user_session_path
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Prihlásiť"
end

Given /^a user with email "([^"]*)" and password "([^"]*)" exists$/ do |email, password|
  User.create!(:email => email, :password => password)
end


Then /^I should be logged in$/ do
  #TODO
end
