Feature: Heuristics management

  Background:
    Given some indexed documents
    And I am logged in as an admin
    And I am searching for documents
    When I restrict search using supplier facet to "varle, s.r.o."
    And I save search as heuristic "Zakazky varlovite" with 5 points and explanation "varle je vzdy podozrive"

  Scenario: Admin defines heuristic by facet restrictions, points, name and description
    And I wait for a while
    And I refresh page
    Then I should see 1 document with 5 points

  Scenario: Admin can see defined heuristic in matching facet restrictions
    And I am searching for documents
    And I restrict search using supplier facet to "varle, s.r.o."
    Then I should see a filled form for heuristic "Zakazky varlovite", 5 points and "varle je vzdy podozrive" as explanation

  Scenario: Admin can edit defined heuristic in matching facet restrictions
    When I update heuristic to "Zakazky Varle, sr.r.o", 20 points and explanation "Varle dava"
    Then I should see a filled form for heuristic "Zakazky Varle, sr.r.o", 20 points and "Varle dava" as explanation
    And I wait for a while
    And I refresh page
    Then I should see 1 document with 20 points

  Scenario: Administrator can delete defined heuristic in matching facet restrictions
    When I delete heuristic
    Then I should see an empty form for heuristic
    And I wait for a while
    And I refresh page
    Then I should see 1 document with 0 points

  Scenario: Admin can list defined heuristics
    When I list defined heuristics
    And I should see a defined heuristic "Zakazky varlovite" with 5 points and explanation "varle je vzdy podozrive"
