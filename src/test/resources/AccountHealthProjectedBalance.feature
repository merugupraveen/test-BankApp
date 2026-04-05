
Feature: Account health and projected balance endpoints
  In order to assess account wellbeing and forecast balances
  As an API client
  I want to call the account health and projection endpoints to get health score/band and projected balances

  @get_account_health @get_account_health_success
  Scenario: Fetch account health for an existing account returns 200 and health details
    Given an account with accountNumber 123456 exists with current balance 1,000 and recent transaction history suitable to compute health
    When the client requests GET /accounts/health/123456
    Then the response status SHOULD be 200
    And the response body SHOULD contain fields "healthScore" and "healthBand"
    And "healthScore" SHOULD be a number (for example 85)
    And "healthBand" SHOULD be one of ["EXCELLENT","GOOD","FAIR","POOR"] (for example "GOOD")

  @get_account_health @get_account_health_not_found
  Scenario: Fetch account health for a non-existent account returns 400 and error message
    Given no account exists with accountNumber 999999
    When the client requests GET /accounts/health/999999
    Then the response status SHOULD be 400
    And the response body SHOULD contain an error message indicating account not found

  @get_account_health @get_account_health_invalid_input
  Scenario: Fetch account health with invalid account number format returns 400 validation error
    Given the account number provided is invalid (for example "abc")
    When the client requests GET /accounts/health/abc
    Then the response status SHOULD be 400
    And the response body SHOULD contain a validation error describing invalid account number format

  @get_account_health @get_account_health_server_error
  Scenario: Unexpected server error while fetching account health returns 500
    Given the service experiences an unexpected internal error computing account health for accountNumber 123456
    When the client requests GET /accounts/health/123456
    Then the response status SHOULD be 500
    And the response body SHOULD contain a generic internal server error message

  @get_projected_balance @projected_balance_success
  Scenario: Get projected balance after valid debit returns 200 and projected balance
    Given an account with accountNumber 111111 exists with currentBalance 1000.00
    When the client requests GET /accounts/projection/111111/200.00
    Then the response status SHOULD be 200
    And the response body SHOULD contain field "projectedBalance"
    And "projectedBalance" SHOULD equal 800.00
    And the response MAY include "currentBalance" and "debitAmount" reflecting the inputs

  @get_projected_balance @projected_balance_insufficient_funds
  Scenario: Get projected balance for a debit that would exceed available funds returns 400 and error
    Given an account with accountNumber 222222 exists with currentBalance 50.00 and overdrafts are not allowed
    When the client requests GET /accounts/projection/222222/120.00
    Then the response status SHOULD be 400
    And the response body SHOULD contain an error indicating insufficient funds or projection not allowed

  @get_projected_balance @projected_balance_invalid_amount
  Scenario: Get projected balance with zero or negative debit amount returns 400 validation error
    Given an account with accountNumber 111111 exists
    When the client requests GET /accounts/projection/111111/0.00
    Then the response status SHOULD be 400
    And the response body SHOULD contain a validation error indicating debitAmount must be greater than zero

  @get_projected_balance @projected_balance_account_not_found
  Scenario: Get projected balance for non-existent account returns 400 and error
    Given no account exists with accountNumber 999888
    When the client requests GET /accounts/projection/999888/50.00
    Then the response status SHOULD be 400
    And the response body SHOULD contain an error indicating account not found

  @get_projected_balance @projected_balance_invalid_input_format
  Scenario: Get projected balance with invalid debitAmount format returns 400
    Given an account with accountNumber 111111 exists
    When the client requests GET /accounts/projection/111111/abc
    Then the response status SHOULD be 400
    And the response body SHOULD contain a validation error describing invalid debitAmount format

  @get_projected_balance @projected_balance_server_error
  Scenario: Unexpected server error while computing projected balance returns 500
    Given the service experiences an unexpected internal error computing projection for accountNumber 111111
    When the client requests GET /accounts/projection/111111/100.00
    Then the response status SHOULD be 500
    And the response body SHOULD contain a generic internal server error message
