@ProductSearch
Feature: Product Search and Category Filtering
  Users can find products using keyword search and category filters.

  Background:
    Given the application is running
    And products exist in the catalog across multiple categories

@byKeyword
  Scenario: Search products by keyword
    Given I am on the product catalog page
    When I search for products with keyword "shoe"
    Then I should see products matching "shoe"
    And I should not see products that do not match "shoe"

@Bycategory
  Scenario: Filter products by category
    Given I am on the product catalog page
    When I filter products by category "Electronics"
    Then I should see only products in category "Electronics"

@byFilter
  Scenario: Search within a category filter
    Given I am on the product catalog page
    And I have filtered products by category "Electronics"
    When I search for products with keyword "charger"
    Then I should see only products in category "Electronics" matching "charger"