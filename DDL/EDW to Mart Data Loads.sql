# EDW to Fact Load - Fact high value loans with LoanCategory derivation

INSERT INTO loans_mart_abinayap.fact_high_value_loans (
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
    LoanCategory,
    load_dt,
    load_ts
)
SELECT
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
    CASE
        WHEN RiskIndicator = 'HIGH'
            THEN 'HIGH_VALUE_HIGH_RISK'
        WHEN RiskIndicator = 'MEDIUM'
            THEN 'HIGH_VALUE_MEDIUM_RISK'
        ELSE 'HIGH_VALUE_LOW_RISK'
    END AS LoanCategory,
    CURRENT_DATE,
    CURRENT_TIMESTAMP
FROM edwdb_abinayap.fact_loans
WHERE HighValueFlag = 'Y';

# Fact Transactions with transaction_flag derivation
INSERT INTO trans_mart_abinayap.fact_transactions (
    AccountID,
    Amount,
    Currency,
    Description,
    EventTs,
    Status,
    Suspicious,
    TransactionDate,
    TransactionFee,
    TransactionID,
    TransactionType,
    transaction_flag
)
SELECT
    AccountID,
    Amount,
    Currency,
    Description,
    EventTs,
    Status,
    Suspicious,
    TransactionDate,
    TransactionFee,
    TransactionID,
    TransactionType,
    CASE WHEN Suspicious THEN 'FLAGGED' ELSE 'NORMAL' END
FROM odsdb_abinayap.ods_transactions;

INSERT INTO trans_mart_abinayap.agg_branch_trans_summary
SELECT 
    b.BranchID,
    b.BranchName,
    COUNT(DISTINCT c.CustomerID) AS Total_Customers,
    COUNT(DISTINCT a.AccountID) AS Total_Accounts,
    SUM(a.Balance) AS Total_Balance,
    SUM(t.Amount) AS Total_Transactions,
    current_date,
    current_timestamp
FROM edwdb_abinayap.dim_branches b
LEFT JOIN edwdb_abinayap.dim_customers c ON c.BranchID = b.BranchID
LEFT JOIN edwdb_abinayap.ods_accounts a ON a.CustomerID = c.CustomerID
LEFT JOIN trans_mart_abianyap.fact_transactions t ON t.AccountID = a.AccountID
GROUP BY b.BranchID, b.BranchName;

# Fact Payments with derived AmountInBaseCurrency
INSERT INTO payment_mart_abinayap.fact_payments (
    Amount,
    AuditTrial,
    ClearingSystem,
    Currency,
    CustomerSegment,
    Description,
    ExchangeRate,
    Fee,
    FromAccountID,
    MerchantName,
    PaymentDate,
    PaymentID,
    PaymentType,
    ToAccountID,
    load_dt,
    load_ts,
    AmountInBaseCurrency
)
SELECT
    Amount,
    AuditTrial,
    ClearingSystem,
    Currency,
    CustomerSegment,
    Description,
    ExchangeRate,
    Fee,
    FromAccountID,
    MerchantName,
    PaymentDate,
    PaymentID,
    PaymentType,
    ToAccountID,
    current_date,
    current_timestamp,
    cast(Amount * ExchangeRate as decimal(18,2))
FROM odsdb_abinayap.ods_payments;

# Star Schema Model: Fact Creditcard with UtilizationPercent
INSERT INTO cc_mart_abinayap.fact_creditcard (
    customerid,
    loanid,
    employeeid,
    firstname,
    phonenumber,
    cardid,
    cardtype,
    balance,
    creditlimit,
    billcycle,
    issuedate,
    utilization_percent,
    load_dt,
    load_ts)
SELECT
    oc.customerid,
    NULL AS loanid,
    NULL AS employeeid,
    dcu.firstname,
    dcu.phonenumber,
    oc.cardid,
    oc.cardtype,
    oc.balance,
    oc.creditlimit,
    oc.billcycle,
    oc.issuedate,
    CASE
        WHEN oc.creditlimit IS NULL
             OR oc.creditlimit = 0
        THEN NULL
        ELSE ROUND(
            (oc.balance / oc.creditlimit) * 100,2)
    END AS utilization_percent,
    oc.load_dt,
    oc.load_ts
FROM odsdb_abinayap.ods_creditcard oc
LEFT JOIN edwdb_abinayap.dim_customers dcu
    ON oc.customerid = dcu.customerid
WHERE oc.load_dt = (
    SELECT MAX(load_dt)
    FROM odsdb_abinayap.ods_creditcard);