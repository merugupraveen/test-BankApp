Feature: Customer REST endpoints
  In order to manage customers and their accounts
  As an API client
  I want to use customers endpoints to list, create, retrieve, update and delete customers

  @get_all_customers @get_all_customers_success
  Scenario: Fetch all customers returns 200 and list of customers
    Given there are customers in the system (for example customerNumbers 1001, 1002)
    When the client requests GET /customers/all
    Then the response status SHOULD be 200
    And the response body SHOULD contain a list of customers including customerNumbers 1001 and 1002

  @get_all_customers @get_all_customers_empty
  Scenario: Fetch all customers when none exist returns 200 and empty list
    Given there are no customers in the system
    When the client requests GET /customers/all
    Then the response status SHOULD be 200
    And the response body SHOULD be an empty list

  @add_customer @add_customer_success
  Scenario: Add a new customer returns 200 and created customer details
    Given the request body contains valid CustomerDetails (for example name, email, address)
    When the client sends POST /customers/add with the customer payload
    Then the response status SHOULD be 200
    And the response body SHOULD contain the created customer details and assigned customerNumber

  @add_customer @add_customer_missing_fields
  Scenario: Add customer with missing required fields returns 400
    Given the request body is missing required fields (for example missing name or invalid email)
    When the client sends POST /customers/add with the incomplete payload
    Then the response status SHOULD be 400
    And the response body SHOULD contain validation error details describing the missing/invalid fields

  @add_customer @add_customer_duplicate
  Scenario: Add customer with duplicate unique information returns 400
    Given a customer already exists with a unique identifier (for example same email or supplied customerNumber)
    When the client sends POST /customers/add with a payload that duplicates that identifier
    Then the response status SHOULD be 400
    And the response body SHOULD indicate the duplicate constraint violation

  @get_customer_by_number @get_customer_success
  Scenario: Fetch existing customer by customer number returns 200 and customer details
    Given a customer with customerNumber 1001 exists
    When the client requests GET /customers/1001
    Then the response status SHOULD be 200
    And the response body SHOULD contain CustomerDetails for customerNumber 1001

  @get_customer_by_number @get_customer_not_found
  Scenario: Fetch non-existent customer returns 400 / appropriate error
    Given no customer exists with customerNumber 9999
    When the client requests GET /customers/9999
    Then the response status SHOULD be 400
    And the response body SHOULD contain an error message indicating customer not found

  @get_customer_by_number @get_customer_invalid_input
  Scenario: Fetch customer with invalid customerNumber format returns 400
    Given the customerNumber provided is invalid (for example "abc")
    When the client requests GET /customers/abc
    Then the response status SHOULD be 400
    And the response body SHOULD contain a validation error message

  @update_customer @update_customer_success
  Scenario: Update existing customer returns 200 and updated details
    Given a customer with customerNumber 1001 exists with current details D1
    And the request body contains valid updated CustomerDetails D2
    When the client sends PUT /customers/1001 with the updated payload
    Then the response status SHOULD be 200
    And the response body SHOULD contain the updated CustomerDetails reflecting D2

  @update_customer @update_customer_not_found
  Scenario: Update non-existent customer returns 400
    Given no customer exists with customerNumber 8888
    When the client sends PUT /customers/8888 with a valid update payload
    Then the response status SHOULD be 400
    And the response body SHOULD contain an error indicating customer not found

  @update_customer @update_customer_invalid_input
  Scenario: Update customer with invalid payload returns 400
    Given a customer with customerNumber 1001 exists
    And the update payload contains invalid fields (for example invalid email format)
    When the client sends PUT /customers/1001 with the invalid payload
    Then the response status SHOULD be 400
    And the response body SHOULD contain validation error details

  @delete_customer @delete_customer_success
  Scenario: Delete existing customer returns 200 and confirmation
    Given a customer with customerNumber 1001 exists and has associated accounts
    When the client sends DELETE /customers/1001
    Then the response status SHOULD be 200
    And the response body SHOULD confirm deletion of customerNumber 1001 and related accounts

  @delete_customer @delete_customer_not_found
  Scenario: Delete non-existent customer returns 400
    Given no customer exists with customerNumber 7777
    When the client sends DELETE /customers/7777
    Then the response status SHOULD be 400
    And the response body SHOULD contain an error indicating customer not found

  @error_handling @server_error
  Scenario: Server-side error returns 500
    Given the service experiences an unexpected error processing the request
    When the client calls any customers endpoint (for example GET /customers/1001)
    Then the response status SHOULD be 500
    And the response body SHOULD contain a generic internal server error message
