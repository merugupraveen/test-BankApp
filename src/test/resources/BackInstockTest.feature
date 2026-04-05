@BIS-Notifications
Feature: Back-in-Stock Notification
  Customers can request back-in-stock notifications and receive an email when available.

  Background:
    Given the application is running
    And email service is configured

@setNotification
  Scenario: Customer requests back-in-stock notification
    Given I am logged in as a customer
    And a product exists with id "P4001" and stock quantity 0
    When I request notification for product "P4001"
    Then my back-in-stock notification request for "P4001" should be saved

@getNotification
  Scenario: Notify customers when product returns to stock
    Given a product exists with id "P4001" and stock quantity 0
    And at least one customer requested notification for product "P4001"
    When an admin updates stock for product "P4001" to 10
    Then back-in-stock emails should be sent to all subscribed customers