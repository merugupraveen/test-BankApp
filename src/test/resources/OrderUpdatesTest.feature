@OrderUpdates
Feature: Admin - Order Fulfillment Updates
  Admins can update shipping and delivery status and notify customers via email.

  Background:
    Given the application is running
    And I am logged in as an admin
    And a customer has placed an order with id "O3001"

@Shipped
  Scenario: Mark an order as shipped
    When I update order "O3001" status to "shipped"
    Then order "O3001" should show status "shipped"
    And a shipment notification email should be sent to the customer

@delivered
  Scenario: Mark an order as delivered
    Given order "O3001" status is "shipped"
    When I update order "O3001" status to "delivered"
    Then order "O3001" should show status "delivered"
    And a delivery notification email should be sent to the customer