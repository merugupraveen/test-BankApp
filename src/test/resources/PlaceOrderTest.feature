@PlaceOrderAll
Feature: Checkout and Order Placement (Demo Payment)
  Authenticated customers can place an order by providing shipping and demo payment details.

  Background:
    Given the application is running
    And I am logged in as a customer
    And my cart contains at least one product

@placeOrder
  Scenario: Place an order successfully
    When I proceed to checkout
    And I provide valid shipping details
    And I provide valid demo card details
    And I confirm the order
    Then an order should be created for my account
    And my cart should be cleared
    And an order confirmation email should be sent to my email address

@checkout
  Scenario: Attempt checkout with empty cart
    Given my cart is empty
    When I proceed to checkout
    Then the system should prevent checkout
    And I should see a message indicating the cart is empty