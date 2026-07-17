# Banking Database Management System (Oracle SQL)

## Overview

This project is a Banking Database Management System developed using Oracle SQL and PL/SQL. The system manages bank branches, employees, customers, accounts, and financial transactions while implementing database security, indexing, stored procedures, functions, and triggers.

## Features

* Manage bank branches and branch telephone numbers.
* Store employee information and manager relationships.
* Maintain customer records and account details.
* Record deposits and withdrawals.
* Assign employees to customer accounts.
* Implement database users and role-based permissions.
* Improve query performance using indexes.
* Automate operations using PL/SQL procedures, functions, and triggers.

## Database Schema

### Tables

1. **Branch**

   * Stores branch information such as branch number, city, postcode, and street.

2. **Telephone_Branch**

   * Stores branch telephone numbers.
   * Linked to the Branch table.

3. **Employee**

   * Stores employee details including salary, position, manager, and assigned branch.

4. **Customers**

   * Stores customer personal information.

5. **Account**

   * Stores account details such as balance and account type.
   * Linked to customers.

6. **Account_Employee**

   * Junction table connecting accounts and employees.

7. **Transactions**

   * Stores customer transaction records including deposits and withdrawals.

## Sample Data

The database includes sample records for:

* 3 Branches
* 3 Employees
* 3 Customers
* 3 Accounts
* 3 Transactions

## Security Implementation

Three database users were created:

### Customer_User

Permissions:

* SELECT on Account
* SELECT on Transactions

### BankEmployee_User

Permissions:

* SELECT, INSERT, UPDATE on Customers
* SELECT, INSERT, UPDATE on Account
* SELECT, INSERT on Transactions

### HR_User

Permissions:

* SELECT, INSERT, UPDATE, DELETE on Employee

## Performance Optimization

### Indexes

1. `idx_branch_city`

   * Created on the Branch city column.
   * Improves branch searches by city.

2. `idx_transaction_amount`

   * Created on the Transactions amount column.
   * Improves transaction amount filtering.

## PL/SQL Components

### Procedure: Add_Customer

Adds a new customer to the Customers table and displays a confirmation message.

### Function: Get_Total_Balance

Calculates and returns the total balance of all accounts owned by a specific customer.

### Trigger: Prevent_Over_Withdrawal

Prevents withdrawal transactions when the withdrawal amount exceeds the customer's available account balance.

## Technologies Used

* Oracle Database
* SQL
* PL/SQL
* Database Security (Users and Privileges)
* Indexing
* Triggers
* Stored Procedures
* Functions

## Learning Outcomes

Through this project, the following database concepts were applied:

* Relational database design
* Primary and foreign key constraints
* Data integrity enforcement
* User privilege management
* Query optimization using indexes
* PL/SQL programming
* Database automation with triggers
* Banking system data management

## Authors
Reem Albattah
