DROP TABLE Branch CASCADE CONSTRAINT;
CREATE TABLE Branch(
   branchNo VARCHAR2(20) PRIMARY KEY,
   postcode VARCHAR2(20),
   city VARCHAR2(10),
   street VARCHAR2(10));
   
DROP TABLE Telephone_Branch CASCADE CONSTRAINT;
CREATE TABLE Telephone_Branch(
   branchNo VARCHAR2(20),
   Telephone VARCHAR2(15),
   constraint PK_Tel PRIMARY KEY (Telephone),
   constraint FK_Tel FOREIGN KEY (branchNo) REFERENCES Branch(branchNo));
   
DROP TABLE Employee CASCADE CONSTRAINT;
CREATE TABLE Employee(
   Employee_ID NUMBER PRIMARY KEY,
   poist VARCHAR2(50),
   Salary NUMBER(10),
   name VARCHAR2(25),
   Manager_ID NUMBER,
   branchNo VARCHAR2(20),
   constraint FK_Manager FOREIGN KEY (Manager_ID) REFERENCES Employee(Employee_ID),
   constraint FK_Branch FOREIGN KEY (branchNo) REFERENCES Branch(branchNo));

DROP TABLE Customers CASCADE CONSTRAINT;
CREATE TABLE Customers(
   Customers_ID NUMBER PRIMARY KEY,
   phone VARCHAR2(15),
   Fname VARCHAR2(25),
   Lname VARCHAR2(25),
   doB DATE);

DROP TABLE Account CASCADE CONSTRAINT;
CREATE TABLE Account(
   Account_ID NUMBER PRIMARY KEY,
   Balance NUMBER(15),
   Account_type VARCHAR2(20),
   Customers_ID NUMBER,
   constraint FK_Account FOREIGN KEY (Customers_ID) REFERENCES Customers(Customers_ID));
   
   
DROP TABLE Account_Employee CASCADE CONSTRAINT;
CREATE TABLE Account_Employee(
   Account_ID NUMBER,
   Employee_ID NUMBER,
   PRIMARY KEY (Account_ID, Employee_ID),
   constraint FK_EAccount FOREIGN KEY (Account_ID) REFERENCES Account(Account_ID),
   constraint FK_AEmployee FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID));
   
   
DROP TABLE Transactions CASCADE CONSTRAINT;
CREATE TABLE Transactions(
   Transaction_ID NUMBER PRIMARY KEY,
   Transaction_Type VARCHAR2(25),
   Transaction_Data DATE,
   Amount NUMBER(15),
   Customers_ID NUMBER,
   constraint FK_TR FOREIGN KEY (Customers_ID) REFERENCES Customers(Customers_ID));


INSERT INTO Branch VALUES ('B100', '123', 'Riyadh', 'MainSt');
INSERT INTO Branch VALUES ('B200', '456', 'Jeddah', 'SecondSt');
INSERT INTO Branch VALUES ('B300', '789', 'Dammam', 'ThirdSt');

INSERT INTO Telephone_Branch VALUES ('B100', '111-111-1111');
INSERT INTO Telephone_Branch VALUES ('B200', '222-222-2222');
INSERT INTO Telephone_Branch VALUES ('B300', '333-333-3333');

INSERT INTO Employee VALUES (1, 'Manager', 5000, 'Lamar', NULL, 'B100');
INSERT INTO Employee VALUES (2, 'Clerk', 3000, 'Nora', 1, 'B100');
INSERT INTO Employee VALUES (3, 'Clerk', 2000, 'sara', 1, 'B200');

INSERT INTO Customers VALUES (1, '111-222-333', 'Ahmed', 'Khalid', TO_DATE('1990-01-01', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (2, '444-555-666', 'Asma', 'Mohammed', TO_DATE('1985-05-05', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (3, '777-888-999', 'Reema', 'Majed', TO_DATE('2000-10-10', 'YYYY-MM-DD'));

INSERT INTO Account VALUES (1, 1200.00, 'Savings', 1);
INSERT INTO Account VALUES (2, 2000.00, 'Checking', 2);
INSERT INTO Account VALUES (3, 1500.00, 'Savings', 3);

INSERT INTO Account_Employee VALUES (1, 1);
INSERT INTO Account_Employee VALUES (2, 2);
INSERT INTO Account_Employee VALUES (3, 3);

INSERT INTO Transactions VALUES (1, 'Deposit', TO_DATE('2024-01-01', 'YYYY-MM-DD'), 500.00, 1);
INSERT INTO Transactions VALUES (2, 'Withdrawal', TO_DATE('2024-02-15', 'YYYY-MM-DD'), 300.00, 2);
INSERT INTO Transactions VALUES (3, 'Deposit', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 1000.00, 3);

DROP USER Customer_user;
DROP USER BankEmployee_user;
DROP USER HR_user;
----1----
CREATE USER Customer_user IDENTIFIED BY customer1234;
GRANT CONNECT to Customer_user;

CREATE USER BankEmployee_user IDENTIFIED BY BankEmploye1234;
GRANT CONNECT to BankEmployee_user;

CREATE USER HR_user IDENTIFIED BY HR1234;
GRANT CONNECT,RESOURCE to HR_user;

----2----
GRANT SELECT ON Account to Customer_user;
GRANT SELECT ON Transactions to Customer_user;
GRANT SELECT,INSERT,UPDATE  on Customers to BankEmployee_user;
GRANT SELECT,INSERT,UPDATE on Account to BankEmployee_user;
GRANT SELECT,INSERT on Transactions to BankEmployee_user;
GRANT SELECT,INSERT,UPDATE,DELETE on Employee to HR_user;

-----3------
CREATE INDEX idx_branch_city ON Branch(city);
SELECT * 
FROM Branch 
WHERE city = 'Riyadh';


CREATE INDEX idx_transaction_amount ON Transactions(Amount);
SELECT * 
FROM Transactions 
WHERE Amount > 500;

-----4------
---precodure----
CREATE OR REPLACE PROCEDURE Add_Customer (
    p_Customers_ID IN NUMBER,
    p_phone IN VARCHAR2,
    p_Fname IN VARCHAR2,
    p_Lname IN VARCHAR2,
    p_dob IN DATE
) AS
BEGIN
    INSERT INTO Customers VALUES (p_Customers_ID, p_phone, p_Fname, p_Lname, p_dob);
    
    DBMS_OUTPUT.PUT_LINE('Customer added successfully.');
END;
/

SET SERVEROUTPUT ON;
BEGIN
    Add_Customer(110, '0551234567', 'Sara', 'AlHarbi', TO_DATE('2003-02-20', 'YYYY-MM-DD'));
END;
/

commit;

----function---
CREATE OR REPLACE FUNCTION Get_Total_Balance (
    p_Customer_ID IN NUMBER
) RETURN NUMBER IS
    total_balance NUMBER := 0;
BEGIN
    SELECT SUM(Balance)
    INTO total_balance
    FROM Account
    WHERE Customers_ID = p_Customer_ID;

    IF total_balance IS NULL THEN
        total_balance := 0;
    END IF;

    RETURN total_balance;
END;
/


set serveroutput on ;
DECLARE 
ID number;
result_ number;
BEGIN
ID:=&ID;
result_:=Get_Total_Balance(ID);
 DBMS_OUTPUT.PUT_LINE('total is: '||result_);
end;
/

---trigger---
CREATE OR REPLACE TRIGGER Prevent_Over_Withdrawal
BEFORE INSERT ON Transactions
FOR EACH ROW
WHEN (NEW.Transaction_Type = 'Withdrawal')
DECLARE
    v_balance NUMBER;
BEGIN
    SELECT Balance INTO v_balance
    FROM Account
    WHERE Customers_ID = :NEW.Customers_ID;

    IF :NEW.Amount > v_balance THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds for withdrawal.');
    END IF;
END;
/


INSERT INTO Transactions (Transaction_ID, Customers_ID, Transaction_Type, Amount)
    VALUES (1001, 1, 'Withdrawal', 50);
	
	INSERT INTO Transactions (Transaction_ID, Customers_ID, Transaction_Type, Amount)
VALUES (1001, 1, 'Withdrawal', 8000);





