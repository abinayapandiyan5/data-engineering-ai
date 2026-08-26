create database stgdb_abinayap;
CREATE TABLE stgdb_abinayap.stg_accounts (
    AccountID VARCHAR(50),
    AccountType VARCHAR(50),
    Balance DECIMAL(18,2),
    CreditScore INT,
    Currency VARCHAR(10),
    CustomerID VARCHAR(50),
    DateOpened DATE,
    ManagerID VARCHAR(50),
    ODLimit DECIMAL(18,2)
);

CREATE TABLE stgdb_abinayap.stg_transactions (
    AccountID VARCHAR(50),
    Amount DECIMAL(18,2),
    Currency VARCHAR(10),
    Description TEXT,
    EventTs TIMESTAMP,
    Status VARCHAR(50),
    Suspicious BOOLEAN,
    TransactionDate DATE,
    TransactionFee DECIMAL(18,2),
    TransactionID VARCHAR(50),
    TransactionType VARCHAR(50));

CREATE TABLE stgdb_abinayap.stg_payments (
    Amount DECIMAL(18,2),
    AuditTrial TEXT,
    ClearingSystem VARCHAR(50),
    Currency VARCHAR(10),
    CustomerSegment VARCHAR(50),
    Description TEXT,
    ExchangeRate DECIMAL(10,4),
    Fee DECIMAL(18,2),
    FromAccountID VARCHAR(50),
    MerchantName VARCHAR(100),
    PaymentDate DATE,
    PaymentID VARCHAR(50),
    PaymentType VARCHAR(50),
    ToAccountID VARCHAR(50)	
);

CREATE TABLE stgdb_abinayap.stg_creditcard (
    Balance DECIMAL(18,2),
    BillCycle VARCHAR(20),
    CardID VARCHAR(50),
    CardNumber VARCHAR(50),
    CardType VARCHAR(50),
    CreditLimit DECIMAL(18,2),
    CustomerID VARCHAR(50),
    ExpirationDate DATE,
    InterestRate DECIMAL(5,2),
    IssueDate DATE,
    Status VARCHAR(20)
);

CREATE TABLE stgdb_abinayap.stg_loans (
    Amount DECIMAL(18,2),
    Collateral VARCHAR(100),
    CustomerID VARCHAR(50),
    EndDate DATE,
    InterestRate DECIMAL(5,2),
    LoanID VARCHAR(50),
    LoanType VARCHAR(50),
    PaymentFrequency VARCHAR(20),
    StartDate DATE,
    Status VARCHAR(20)
);

CREATE TABLE stgdb_abinayap.stg_cust_profile (
    Address TEXT,
    BranchID VARCHAR(50),
    CustomerID VARCHAR(50),
    DateOfBirth DATE,
    Email VARCHAR(100),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    PhoneNumber VARCHAR(20)
);


CREATE TABLE stgdb_abinayap.stg_branches (
    Address TEXT,
    BranchID VARCHAR(50),
    BranchName VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Zipcode VARCHAR(20));

CREATE TABLE stgdb_abinayap.stg_employees (
    BranchID VARCHAR(50),
    EmployeeID VARCHAR(50),
    FirstName VARCHAR(100),
    Hiredate DATE,
    LastName VARCHAR(100),
    ManagerID VARCHAR(50),
    Position VARCHAR(100));
	
create database odsdb_abinayap;

CREATE TABLE odsdb_abinayap.ods_accounts (
    AccountID VARCHAR(50),
    AccountType VARCHAR(50),
    Balance DECIMAL(18,2),
    CreditScore INT,
    Currency VARCHAR(10),
    CustomerID VARCHAR(50),
    DateOpened DATE,
    ManagerID VARCHAR(50),
    ODLimit DECIMAL(18,2),
    load_dt DATE,
    load_ts TIMESTAMP
);

CREATE TABLE odsdb_abinayap.ods_transactions (
    AccountID VARCHAR(50),
    Amount DECIMAL(18,2),
    Currency VARCHAR(10),
    Description TEXT,
    EventTs TIMESTAMP,
    Status VARCHAR(50),
    Suspicious BOOLEAN,
    TransactionDate DATE,
    TransactionFee DECIMAL(18,2),
    TransactionID VARCHAR(50),
    TransactionType VARCHAR(50),
    load_dt DATE,
    load_ts TIMESTAMP
);

CREATE TABLE odsdb_abinayap.ods_payments (
    Amount DECIMAL(18,2),
    AuditTrial TEXT,
    ClearingSystem VARCHAR(50),
    Currency VARCHAR(10),
    CustomerSegment VARCHAR(50),
    Description TEXT,
    ExchangeRate DECIMAL(10,4),
    Fee DECIMAL(18,2),
    FromAccountID VARCHAR(50),
    MerchantName VARCHAR(100),
    PaymentDate DATE,
    PaymentID VARCHAR(50),
    PaymentType VARCHAR(50),
    ToAccountID VARCHAR(50),
    load_dt DATE,
    load_ts TIMESTAMP
);

CREATE TABLE odsdb_abinayap.ods_creditcard (
    Balance DECIMAL(18,2),
    BillCycle VARCHAR(20),
    CardID VARCHAR(50),
    CardNumber VARCHAR(50),
    CardType VARCHAR(50),
    CreditLimit DECIMAL(18,2),
    CustomerID VARCHAR(50),
    ExpirationDate DATE,
    InterestRate DECIMAL(5,2),
    IssueDate DATE,
    Status VARCHAR(20),
    load_dt DATE,
    load_ts TIMESTAMP
);

CREATE TABLE odsdb_abinayap.ods_loans (
    Amount DECIMAL(18,2),
    Collateral VARCHAR(100),
    CustomerID VARCHAR(50),
    EndDate DATE,
    InterestRate DECIMAL(5,2),
    LoanID VARCHAR(50),
    LoanType VARCHAR(50),
    PaymentFrequency VARCHAR(20),
    StartDate DATE,
    Status VARCHAR(20),
    load_dt DATE,
    load_ts TIMESTAMP
);

CREATE TABLE odsdb_abinayap.ods_cust_profile (
    Address TEXT,
    BranchID VARCHAR(50),
    CustomerID VARCHAR(50),
    DateOfBirth DATE,
    Email VARCHAR(100),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    PhoneNumber VARCHAR(20),
    load_dt DATE,
    load_ts TIMESTAMP
);

CREATE TABLE odsdb_abinayap.ods_branches (
    Address TEXT,
    BranchID VARCHAR(50),
    BranchName VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Zipcode VARCHAR(20),
    load_dt DATE,
    load_ts TIMESTAMP
);

CREATE TABLE odsdb_abinayap.ods_employees (
    BranchID VARCHAR(50),
    EmployeeID VARCHAR(50),
    FirstName VARCHAR(100),
    Hiredate DATE,
    LastName VARCHAR(100),
    ManagerID VARCHAR(50),
    Position VARCHAR(100),
    load_dt DATE,
    load_ts TIMESTAMP
);


create database edwdb_abinayap;
CREATE TABLE edwdb_abinayap.dim_customers (
    CustomerID VARCHAR(50),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20),
    Address TEXT,
    DateOfBirth DATE,
    BranchID VARCHAR(50),
    load_dt DATE,
    load_ts TIMESTAMP,
    effective_date DATE
);

CREATE TABLE edwdb_abinayap.dim_branches (
    Address TEXT,
    BranchID VARCHAR(50),
    BranchName VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Zipcode VARCHAR(20),
    load_dt DATE,
    load_ts TIMESTAMP,
    start_date DATE,
    end_date DATE,
    is_current TINYINT
);

CREATE TABLE edwdb_abinayap.dim_employees (
    BranchID VARCHAR(50),
    EmployeeID VARCHAR(50),
    FirstName VARCHAR(100),
    Hiredate DATE,
    LastName VARCHAR(100),
    ManagerID VARCHAR(50),
    Position VARCHAR(100),
    load_dt DATE,
    load_ts TIMESTAMP
);

CREATE TABLE edwdb_abinayap.dim_loans (
    Amount DECIMAL(18,2),
    Collateral VARCHAR(100),
    CustomerID VARCHAR(50),
    EndDate DATE,
    InterestRate DECIMAL(5,2),
    LoanID VARCHAR(50),
    LoanType VARCHAR(50),
    PaymentFrequency VARCHAR(20),
    StartDate DATE,
    Status VARCHAR(20),
    load_dt DATE,
    load_ts TIMESTAMP
);

CREATE TABLE edwdb_abinayap.fact_loans (
    LoanID bigint NOT NULL,
    CustomerID INT NOT NULL,
    BranchID INT NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    InterestRate DECIMAL(5,2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PaymentFrequency VARCHAR(20),
    Status VARCHAR(20),
    OutstandingBalance DECIMAL(18,2),
    LoanDurationMonths INT,
    RiskIndicator VARCHAR(10),
    HighValueFlag CHAR(1),
    load_dt DATE NOT NULL,
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE DATABASE loans_mart_abinayap;

CREATE TABLE loans_mart_abinayap.fact_high_value_loans (
    LoanID                  INT,
    CustomerID              INT,
    BranchID                INT,
    Amount                  DECIMAL(18,2),
    InterestRate            DECIMAL(10,2),
    StartDate               DATE,
    EndDate                 DATE,
    PaymentFrequency        VARCHAR(50),
    Status                  VARCHAR(50),
    OutstandingBalance      DECIMAL(18,2),
    LoanDurationMonths      INT,
    RiskIndicator            VARCHAR(20),
    HighValueFlag           CHAR(1),
    LoanCategory             VARCHAR(30),
    load_dt                 DATE,
    load_ts                 TIMESTAMP
);

CREATE TABLE IF NOT EXISTS edwdb_abinayap.fact_loan_summary (
    BranchID                INT,
    RiskIndicator           VARCHAR(20),
    LoanCount               INT,
    TotalLoanAmount         DECIMAL(18,2),
    AverageLoanAmount       DECIMAL(18,2),
    MaximumLoanAmount       DECIMAL(18,2),
    MinimumLoanAmount       DECIMAL(18,2),
    HighValueLoanCount      INT,
    HighValueLoanAmount     DECIMAL(18,2),
    ActiveLoanCount         INT,
    ClosedLoanCount         INT,
    AverageInterestRate     DECIMAL(10,2),
    AverageLoanDurationMonths DECIMAL(10,2),
    load_dt                 DATE,
    load_ts                 TIMESTAMP);

create database trans_mart_abinayap;
CREATE TABLE trans_mart_abinayap.fact_transactions (
    AccountID VARCHAR(50),
    Amount DECIMAL(18,2),
    Currency VARCHAR(10),
    Description TEXT,
    EventTs TIMESTAMP,
    Status VARCHAR(50),
    Suspicious BOOLEAN,
    TransactionDate DATE,
    TransactionFee DECIMAL(18,2),
    TransactionID VARCHAR(50),
    TransactionType VARCHAR(50),
    load_dt DATE,
    load_ts TIMESTAMP,
    transaction_flag VARCHAR(10)
);

CREATE TABLE trans_mart_abinayap.agg_branch_trans_summary (
    BranchID                INT NOT NULL,
    BranchName              VARCHAR(100),

    Total_Customers        INT DEFAULT 0,
    Total_Accounts         INT DEFAULT 0,
    Total_Balance          DECIMAL(18,2) DEFAULT 0.00,
    Total_Transactions     DECIMAL(18,2) DEFAULT 0.00,

    load_dt                DATE,
    load_ts                TIMESTAMP);

create database payment_mart_abinayap;
CREATE TABLE payment_mart_abinayap.fact_payments (
    Amount DECIMAL(18,2),
    AuditTrial TEXT,
    ClearingSystem VARCHAR(50),
    Currency VARCHAR(10),
    CustomerSegment VARCHAR(50),
    Description TEXT,
    ExchangeRate DECIMAL(10,4),
    Fee DECIMAL(18,2),
    FromAccountID VARCHAR(50),
    MerchantName VARCHAR(100),
    PaymentDate DATE,
    PaymentID VARCHAR(50),
    PaymentType VARCHAR(50),
    ToAccountID VARCHAR(50),
    load_dt DATE,
    load_ts TIMESTAMP,
    AmountInBaseCurrency DECIMAL(18,2)
);

create database cc_mart_abinayap;
CREATE TABLE cc_mart_abinayap.fact_creditcard (
    fact_creditcard_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customerid INT,
    loanid BIGINT,
    employeeid INT,
    firstname VARCHAR(100),
    phonenumber VARCHAR(20),
    cardid BIGINT,
    cardtype VARCHAR(50),
    balance DECIMAL(15,2),
    creditlimit DECIMAL(15,2),
    billcycle VARCHAR(20),
    issuedate DATE,
    utilization_percent DECIMAL(5,2),
    load_dt DATE,
    load_ts TIMESTAMP);
