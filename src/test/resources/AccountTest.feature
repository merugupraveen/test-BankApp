@AddCard
Feature: Shopping Cart - Add Items
  Authenticated customers can add products to their cart.

  Background:
    Given the application is running
    And I am logged in as a customer
    And a product exists with id "P1001"

@AddOneItem
  Scenario: Add a product to cart
    Given my cart is empty
    When I add product "P1001" to my cart
    Then my cart should contain product "P1001" with quantity 1
@RepeatItem
  Scenario: Add the same product again
    Given my cart contains product "P1001" with quantity 1
    When I add product "P1001" to my cart again
    Then my cart should contain product "P1001" with quantity 2