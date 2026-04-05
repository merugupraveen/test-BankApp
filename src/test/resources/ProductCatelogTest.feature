@productcatelog
Feature: Product Catalog Browsing
  Users can view product listings and images.

  Background:
    Given the application is running
    And products exist in the catalog

@viewcatelog
  Scenario: View catalog listing
    Given I am on the product catalog page
    When the page loads
    Then I should see a list of products
    And each product should show name and price

@viewImage
  Scenario: View product image
    Given I am on the product catalog page
    When I request the image for a listed product
    Then the product image should be displayed