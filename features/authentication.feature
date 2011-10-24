Feature: Authenticating users

  Scenario: Logging in with non-existing email
    Given I am not logged in
    And no user with email "eva@afp.sk" exists
    When I login as "eva@afp.sk" with password "secret"
    Then I should see "Zadali ste zlý email alebo heslo"

  Scenario: Logging in as existing user
    Given I am not logged in
    And a user with email "eva@afp.sk" and password "secret" exists
    When I login as "eva@afp.sk" with password "secret"
    Then I should be logged in

