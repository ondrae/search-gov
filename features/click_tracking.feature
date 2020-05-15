Feature: Click tracking behavior
  @javascript
  Scenario: Clicking on search results creates loglines
    Given the following Affiliates exist:
      | display_name | name       | contact_email      | first_name      | last_name     |
      | Example Site | agency.gov | admin@agency.gov   | Frances         | Perkins       |
    And the following Boosted Content entries exist for the affiliate "agency.gov"
      | url                | title          | description                      |
      | http://example.com | A boosted link | We're going to click on this one |

    When I am on agency.gov's search page
    And I fill in "Enter your search term" with "boosted"
    And I press "Search"
    Then a click should get logged
    When I follow "A boosted link"
