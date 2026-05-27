Feature: Accounts and Transactions REST endpoints
  In order to manage bank accounts and transactions
  As an API client
  I want to use the accounts endpoints to fetch account info, create accounts, transfer funds and list transactions

  @get_account_by_number @get_account_success
  Scenario: Fetch existing account by account number returns 200 and account details
    Given an account with accountNumber 123456 exists for customer 1001
    When the client requests GET /accounts/123456
    Then the response status SHOULD be 200
    And the response body SHOULD contain account details for accountNumber 123456

  @get_account_by_number @get_account_not_found
  Scenario: Fetch non-existent account returns 400 / appropriate error
    Given no account exists with accountNumber 999999
    When the client requests GET /accounts/999999
    Then the response status SHOULD be 400
    And the response body SHOULD contain an error message indicating account not found

  @get_account_by_number @get_account_invalid_input
  Scenario: Fetch account with invalid account number format returns 400
    Given the account number provided is invalid (e.g. "abc")
    When the client requests GET /accounts/abc
    Then the response status SHOULD be 400
    And the response body SHOULD contain a validation error message

  @add_new_account @add_account_success
  Scenario: Add a new account for an existing customer returns 200 and created account
    Given a customer with customerNumber 1001 exists
    And the request body contains valid account information (e.g. accountType, initialBalance, accountNumber optional)
    When the client sends POST /accounts/add/1001 with the account payload
    Then the response status SHOULD be 200
    And the response body SHOULD contain the created account details including assigned accountNumber and customerNumber 1001

  @add_new_account @add_account_missing_fields
  Scenario: Add account with missing required fields returns 400
    Given a customer with customerNumber 1001 exists
    And the request body is missing required fields (e.g. no accountType or invalid initialBalance)
    When the client sends POST /accounts/add/1001 with the incomplete payload
    Then the response status SHOULD be 400
    And the response body SHOULD contain validation error details describing the missing/invalid fields

  @add_new_account @add_account_customer_not_found
  Scenario: Add account for non-existent customer returns 400
    Given no customer exists with customerNumber 9999
    When the client sends POST /accounts/add/9999 with a valid account payload
    Then the response status SHOULD be 400
    And the response body SHOULD contain an error indicating the customer was not found

  @transfer_fund @transfer_fund_success
  Scenario: Transfer funds between two valid accounts for same customer returns 200 and confirmation
    Given customerNumber 1001 exists and owns account 111111 with balance 1000 and account 222222 with balance 100
    And the transfer request body contains fromAccount 111111, toAccount 222222, amount 200
    When the client sends PUT /accounts/transfer/1001 with the transfer payload
    Then the response status SHOULD be 200
    And the response body SHOULD confirm the transfer and show updated balances (111111: 800, 222222: 300)

  @transfer_fund @transfer_insufficient_funds
  Scenario: Transfer fails with insufficient funds returns 400 and error message
    Given customerNumber 1001 exists and owns account 333333 with balance 50
    And account 444444 exists and is eligible to receive funds
    And the transfer request body contains fromAccount 333333, toAccount 444444, amount 100
    When the client sends PUT /accounts/transfer/1001 with the transfer payload
    Then the response status SHOULD be 400
    And the response body SHOULD contain an error indicating insufficient funds

  @transfer_fund @transfer_invalid_accounts
  Scenario: Transfer fails when source or destination account does not exist returns 400
    Given customerNumber 1001 exists
    And no account exists with accountNumber 777777
    When the client sends PUT /accounts/transfer/1001 with fromAccount 777777, toAccount 888888, amount 50
    Then the response status SHOULD be 400
    And the response body SHOULD indicate invalid or non-existent account(s)

  @transfer_fund @transfer_negative_amount
  Scenario: Transfer with negative or zero amount returns 400 validation error
    Given customerNumber 1001 exists and accounts 111111 and 222222 exist
    When the client sends PUT /accounts/transfer/1001 with amount 0 (or amount -10)
    Then the response status SHOULD be 400
    And the response body SHOULD contain a validation error indicating amount must be greater than zero

  @transfer_fund @transfer_unauthorized_customer
  Scenario: Transfer request with mismatched customerNumber (not owner of fromAccount) returns 400
    Given account 555555 is owned by customer 2002 (not 1001)
    When the client sends PUT /accounts/transfer/1001 with fromAccount 555555, toAccount 666666, amount 10
    Then the response status SHOULD be 400
    And the response body SHOULD indicate that the customer is not authorized to transfer from that account

  @get_transactions @get_transactions_success
  Scenario: Get all transactions for an account returns 200 and list of transactions
    Given account 111111 exists and has transactions t1, t2, t3
    When the client requests GET /accounts/transactions/111111
    Then the response status SHOULD be 200
    And the response body SHOULD be a list containing transactions t1, t2, t3 for account 111111

  @get_transactions @get_transactions_empty
  Scenario: Get transactions for an account with no transactions returns 200 and empty list
    Given account 999888 exists and has no transactions
    When the client requests GET /accounts/transactions/999888
    Then the response status SHOULD be 200
    And the response body SHOULD be an empty list

  @get_transactions @get_transactions_account_not_found
  Scenario: Get transactions for non-existent account returns 400
    Given no account exists with accountNumber 444999
    When the client requests GET /accounts/transactions/444999
    Then the response status SHOULD be 400
    And the response body SHOULD contain an error indicating account not found

  @error_handling @server_error
  Scenario: Server-side error returns 500
    Given the service experiences an unexpected error processing the request
    When the client calls any accounts endpoint (for example GET /accounts/123456)
    Then the response status SHOULD be 500
    And the response body SHOULD contain a generic internal server error message
