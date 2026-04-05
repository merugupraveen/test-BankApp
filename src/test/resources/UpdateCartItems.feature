@UpdateCartItems
Feature: Shopping Cart - Update Quantity and Remove Items
  Authenticated customers can change quantities or remove items.

  Background:
    Given the application is running
    And I am logged in as a customer
    And my cart contains product "P1001" with quantity 2

@increasecart
  Scenario: Increase cart item quantity
    When I increase quantity of product "P1001" to 3
    Then my cart should contain product "P1001" with quantity 3
    And the cart total should be recalculated
@decreasecart
  Scenario: Decrease cart item quantity
    When I decrease quantity of product "P1001" to 1
    Then my cart should contain product "P1001" with quantity 1
    And the cart total should be recalculated

@removeItemfromCart
  Scenario: Remove an item from the cart
    When I remove product "P1001" from my cart
    Then my cart should not contain product "P1001"
    And the cart total should be recalculated