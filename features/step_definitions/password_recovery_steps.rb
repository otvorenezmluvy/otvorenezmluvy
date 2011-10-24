When /^I request the password reset for email "([^"]*)"$/ do |email|
  visit new_user_password_path
  fill_in "user_email", :with => email
  click_button "Poslať inštrukcie na zresetovanie hesla"
end

Then /^the email address "([^"]*)" should receive the password recovery link$/ do |email|
  Then %{"#{email}" should receive an email}
  And %{I open the email}
  And %{I should see "Change my password" in the email body}
end

When /^I click the password reset link$/ do
  When %{I click the first link in the email}
end

When /^I set my new password to be "([^"]*)"$/ do |password|
  fill_in "user_password", :with => password
  fill_in "user_password_confirmation", :with => password
  click_button "Change my password"
end

Then /^I should be able to login as "([^"]*)" with password "([^"]*)"$/ do |user, password|
  Given %{I am not logged in}
  And %{I login as "#{user}" with password "#{password}"}
  Then %{I should be logged in}
end

