Feature: Fulltext Search

  Background:
    Given some indexed documents
    And I am searching for documents

  Scenario: Searching for documents with highlighting
    When I search for "minio.sk"
    Then I should see 1 matching document
    And I should see "minio.sk" highlighted on 5 pages

  Scenario: Opening a document from fulltext query
    When I search for "minio.sk"
    And I open a matching document
    Then I should see quicksearch results for "minio.sk"

  Scenario: Searching with no results
    When I search for "bogus"
    Then I should see 0 matching documents