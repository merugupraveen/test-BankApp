@OrderTracking
Feature: Customer Order History and Tracking
  Customers can view past orders and track shipping status.

  Background:
    Given the application is running
    And I am logged in as a customer
    And I have at least one order in my order history

@historylink
  Scenario: View order history
    When I open my order history page
    Then I should see a list of my orders

@shipstatus
  Scenario: View order details including shipping status
    When I open the details page for an order
    Then I should see the ordered items and totals
    And I should see the current shipping status