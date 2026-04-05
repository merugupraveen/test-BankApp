@CustRegistration
Feature: Customer Registration
  Customers can create accounts and receive a confirmation email.

  Background:
    Given the application is running
    And email service is configured

@ValidReg
  Scenario: Register with valid details
    Given I am a visitor
    When I submit registration with valid name, email, password, phone, and address
    Then a new customer account should be created
    And a registration success email should be sent to my email address
    And I should be able to log in with the registered credentials

@DuplicateReg
  Scenario: Register with an email that already exists
    Given a customer account exists with email "user@example.com"
    When I submit registration with email "user@example.com"
    Then the system should reject the registration
    And I should see an error message indicating the email is already registered