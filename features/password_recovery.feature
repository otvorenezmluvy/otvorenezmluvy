Feature: Recovering passwords

  Scenario: Unlogged user can recover password
    Given I am not logged in
    And a user with email "eva@afp.sk" and password "secret" exists
    When I request the password reset for email "eva@afp.sk"
    Then the email address "eva@afp.sk" should receive the password recovery link
    When I click the password reset link
    Then I should see "Change your password"
    When I set my new password to be "forever"
    Then I should be able to login as "eva@afp.sk" with password "forever"
