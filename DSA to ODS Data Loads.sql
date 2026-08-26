# ODS loads from staging with exact copy
# ODS Load from Staging with load_dt and load_ts

INSERT INTO odsdb_abinayap.ods_accounts
SELECT AccountID,trim(AccountType),Balance,CreditScore,upper(Currency),CustomerID,DateOpened,ManagerID,ODLimit,
CURRENT_DATE AS load_dt, CURRENT_TIMESTAMP AS load_ts
FROM stgdb_abinayap.stg_accounts where AccountID is not null; 
	
INSERT INTO odsdb_abinayap.ods_transactions
SELECT t.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb_abinayap.stg_transactions t;

INSERT INTO odsdb_abinayap.ods_payments
SELECT p.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb_abinayap.stg_payments p;

INSERT INTO odsdb_abinayap.ods_creditcard
SELECT c.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb_abinayap.stg_creditcard c;

INSERT INTO odsdb_abinayap.ods_loans
SELECT l.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb_abinayap.stg_loans l;

INSERT INTO odsdb_abinayap.ods_cust_profile
SELECT Address,
    BranchID,
    CustomerID,
    DateOfBirth,
    Email,
    trim(FirstName),
    trim(LastName),
    substr(PhoneNumber,1,20), 
    CURRENT_DATE AS load_dt, 
    CURRENT_TIMESTAMP AS load_ts
FROM stgdb_abinayap.stg_cust_profile cp;

INSERT INTO odsdb_abinayap.ods_branches
SELECT b.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb_abinayap.stg_branches b;

INSERT INTO odsdb_abinayap.ods_employees
SELECT e.*, 
       CURRENT_DATE AS load_dt, 
       CURRENT_TIMESTAMP AS load_ts
FROM stgdb_abinayap.stg_employees e;
