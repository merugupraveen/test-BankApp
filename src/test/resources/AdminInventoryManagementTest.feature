@InventoryManagement
Feature: Admin - Inventory Management
  Admins can add, update, and remove products from inventory.

  Background:
    Given the application is running
    And I am logged in as an admin

@AddProduct
  Scenario: Add a new product
    When I add a product with name, category, description, price, quantity, and image
    Then the product should be created in inventory
    And the product should appear in the customer catalog

@UpdateProduct
  Scenario: Update an existing product
    Given a product exists with id "P2001"
    When I update product "P2001" price and quantity
    Then product "P2001" should reflect the updated price and quantity in inventory
    And the customer catalog should show the updated product details

@RemoveProduct
  Scenario: Remove a product
    Given a product exists with id "P2002"
    When I remove product "P2002" from inventory
    Then product "P2002" should not appear in inventory
    And product "P2002" should not appear in the customer catalog