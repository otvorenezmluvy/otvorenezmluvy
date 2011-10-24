Feature: Faceted search

  Background:
    Given some indexed documents
    And I am searching for documents

  Scenario: User can restrict contracts list by supplier facet
    When I restrict search using supplier facet to "minio, s.r.o."
    Then I should see only documents with "minio, s.r.o." as supplier

  Scenario: User can add another restriction
    Given I restrict search using supplier facet to "minio, s.r.o."
    And I restrict search using published_on facet to "01. 2011"
    Then I should see only documents with "minio, s.r.o." as supplier
    And I should see only documents with "2011-01" in publication date

  Scenario: User can remove a restriction
    Given I restrict search using supplier facet to "minio, s.r.o."
    Then I should see 1 matching document
    When I remove "minio, s.r.o." restriction from supplier facet
    Then I should see 2 matching documents

  Scenario Outline: User can sort results by ordinal field
    When I sort results by <field>
    Then I should see matching documents sorted by <field_name>

  Scenarios: Sortable fields
    | field_name   | field              |
    | total_amount | Celkovej sumy      |
    | published_on | Dátumu zverejnenia |
    | points       | Zaujímavosti       |

  Scenario: User can remove all restrictions
    When I restrict search using supplier facet to "minio, s.r.o."
    And I remove all restrictions
    Then I should see no restrictions applied