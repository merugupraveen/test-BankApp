@CustomerAuth
Feature: Customer Authentication
  Customers can log in to access shopping features and log out to end their session.

  Background:
    Given the application is running
    And a customer account exists with email "user@example.com" and password "Password@123"

@validAuth
  Scenario: Login with valid credentials
    Given I am a visitor
    When I log in with email "user@example.com" and password "Password@123"
    Then I should be authenticated
    And I should see the product catalog page

@invalidAuth
  Scenario: Login with invalid password
    Given I am a visitor
    When I log in with email "user@example.com" and password "WrongPass"
    Then I should not be authenticated
    And I should see an error message for invalid credentials

@logout
  Scenario: Logout from an authenticated session
    Given I am logged in as customer "user@example.com"
    When I click logout
    Then my session should be terminated
    And I should be redirected to the home page