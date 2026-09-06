truncate table edwdb_abinayap.dim_customers;

INSERT INTO edwdb_abinayap.dim_customers (
    CustomerID,
    FirstName,
    LastName,
    Email,
    PhoneNumber,
    Address,
    DateOfBirth,
    BranchID,
    effective_date
)
SELECT DISTINCT
    CustomerID,
    FirstName,
    LastName,
    Email,
    PhoneNumber,
    Address,
    DateOfBirth,
    BranchID,
    CURRENT_DATE
FROM odsdb_abinayap.ods_cust_profile;

# SCD Type 2 Starts here
SET SQL_SAFE_UPDATES = 0;

UPDATE edwdb_abinayap.dim_branches d
JOIN odsdb_abinayap.ods_branches o
  ON d.BranchID = o.BranchID
SET d.end_date = CURRENT_DATE - INTERVAL 1 DAY,
    d.is_current = 0
WHERE d.is_current = 1
  AND (d.Address   <> o.Address
    OR d.BranchName <> o.BranchName
    OR d.City       <> o.City
    OR d.State      <> o.State
    OR d.Zipcode    <> o.Zipcode);

INSERT INTO edwdb_abinayap.dim_branches (
    Address,
    BranchID,
    BranchName,
    City,
    State,
    Zipcode,
    start_date,
    end_date,
    is_current
)
SELECT
    o.Address,
    o.BranchID,
    o.BranchName,
    o.City,
    o.State,
    o.Zipcode,
    CURRENT_DATE,
    NULL,
    1
FROM odsdb_abinayap.ods_branches o
LEFT JOIN edwdb_abinayap.dim_branches d
       ON o.BranchID = d.BranchID
      AND d.is_current = 1
WHERE d.BranchID IS NULL
   OR d.Address   <> o.Address
   OR d.BranchName <> o.BranchName
   OR d.City       <> o.City
   OR d.State      <> o.State
   OR d.Zipcode    <> o.Zipcode;

# SCD Type 2 Ends here

INSERT INTO edwdb_abinayap.dim_employees (
    BranchID,
    EmployeeID,
    FirstName,
    Hiredate,
    LastName,
    ManagerID,
    Position
)
SELECT
    BranchID,
    EmployeeID,
    FirstName,
    Hiredate,
    LastName,
    ManagerID,
    Position
FROM odsdb_abinayap.ods_employees;

INSERT INTO edwdb_abinayap.dim_loans (
    Amount,
    Collateral,
    CustomerID,
    EndDate,
    InterestRate,
    LoanID,
    LoanType,
    PaymentFrequency,
    StartDate,
    Status
)
SELECT
    Amount,
    Collateral,
    CustomerID,
    EndDate,
    InterestRate,
    LoanID,
    LoanType,
    PaymentFrequency,
    StartDate,
    Status
FROM odsdb_abinayap.ods_loans;


# EDW Fact Load
INSERT INTO edwdb_abinayap.fact_loans (
    LoanID,
    CustomerID,
    BranchID,
    Amount,
    InterestRate,
    StartDate,
    EndDate,
    PaymentFrequency,
    Status,
    OutstandingBalance,
    LoanDurationMonths,
    RiskIndicator,
    HighValueFlag,
    load_dt,
    load_ts
)
SELECT distinct
    o.LoanID,
    c.CustomerID,          # from dim_customers
    b.BranchID,            # from dim_branches
    o.Amount,
    o.InterestRate,
    o.StartDate,
    o.EndDate,
    o.PaymentFrequency,
    o.Status,
    o.Amount AS OutstandingBalance,
    TIMESTAMPDIFF(MONTH, o.StartDate, o.EndDate) AS LoanDurationMonths,
    CASE 
        WHEN o.InterestRate > 12 THEN 'HIGH'
        WHEN o.InterestRate BETWEEN 8 AND 12 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS RiskIndicator,
    CASE 
        WHEN o.Amount >= 80000 THEN 'Y'
        ELSE 'N'
    END AS HighValueFlag,
    CURRENT_DATE,
    CURRENT_TIMESTAMP
FROM odsdb_abinayap.ods_loans o
LEFT JOIN edwdb_abinayap.dim_customers c
    ON o.CustomerID = c.CustomerID
LEFT JOIN edwdb_abinayap.dim_branches b
    ON c.BranchID = b.BranchID
   AND b.is_current = 1;

# EDW Summary Load
INSERT INTO edwdb_abinayap.fact_loan_summary (
    BranchID,
    RiskIndicator,
    LoanCount,
    TotalLoanAmount,
    AverageLoanAmount,
    MaximumLoanAmount,
    MinimumLoanAmount,
    HighValueLoanCount,
    HighValueLoanAmount,
    ActiveLoanCount,
    ClosedLoanCount,
    AverageInterestRate,
    AverageLoanDurationMonths,
    load_dt,
    load_ts)
SELECT
    BranchID,
    RiskIndicator,
    COUNT(*) AS LoanCount,
    SUM(Amount) AS TotalLoanAmount,
    ROUND(AVG(Amount), 2) AS AverageLoanAmount,
    MAX(Amount) AS MaximumLoanAmount,
    MIN(Amount) AS MinimumLoanAmount,
    SUM(
        CASE
            WHEN HighValueFlag = 'Y' THEN 1
            ELSE 0
        END
    ) AS HighValueLoanCount,
    SUM(
        CASE
            WHEN HighValueFlag = 'Y' THEN Amount
            ELSE 0
        END
    ) AS HighValueLoanAmount,
    SUM(
        CASE
            WHEN Status = 'ACTIVE' THEN 1
            ELSE 0
        END
    ) AS ActiveLoanCount,
    SUM(
        CASE
            WHEN Status = 'CLOSED' THEN 1
            ELSE 0
        END
    ) AS ClosedLoanCount,
    ROUND(AVG(InterestRate), 2) AS AverageInterestRate,
    ROUND(AVG(LoanDurationMonths), 2)
        AS AverageLoanDurationMonths,
    CURRENT_DATE,
    CURRENT_TIMESTAMP
FROM edwdb_abinayap.fact_loans
GROUP BY
    BranchID,
    RiskIndicator;