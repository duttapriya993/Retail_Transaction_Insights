﻿--Step1: SQL Setup & Data Loading
CREATE DATABASE
CustomerTransactionDB;
USE CustomerTransactionDB;
EXEC sp_help 'transactions';
EXEC sp_help 'customers';
EXEC sp_help 'merchants';

--Step 2: Preview,Count & Null Checks
--Step 2.1: Preview Top Rows
SELECT TOP 5 * From customers;
SELECT TOP 5 * From merchants;
SELECT TOP 5 * From transactions;

--Step 2.2: Count Total Records
 SELECT COUNT(*) AS Total_customers FROM customers;
 SELECT COUNT(*) AS Total_Merchants FROM merchants;
 SELECT COUNT(*) AS Total_Transactions FROM Transactions;

 --Step 2.3: Check For Null Values
 --Customers Table- Null Check
 SELECT 
  SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Null_CustomerID,
  SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Null_Name,
  SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
  SUM(CASE WHEN AgeGroup IS NULL THEN 1 ELSE 0 END) AS Null_AgeGroup,
  SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Null_Region,
  SUM(CASE WHEN SignupDate IS NULL THEN 1 ELSE 0 END) AS Null_SignupDate
FROM Customers;

--Merchants Table- Null Check
SELECT 
  SUM(CASE WHEN MerchantID IS NULL THEN 1 ELSE 0 END) AS Null_MerchantID,
  SUM(CASE WHEN MerchantName IS NULL THEN 1 ELSE 0 END) AS Null_MerchantName,
  SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS Null_Category,
  SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
  SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Null_Country
FROM Merchants;

--Transactions Table- Null check
SELECT 
  SUM(CASE WHEN TransactionID IS NULL THEN 1 ELSE 0 END) AS Null_TransactionID,
  SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Null_CustomerID,
  SUM(CASE WHEN MerchantID IS NULL THEN 1 ELSE 0 END) AS Null_MerchantID,
  SUM(CASE WHEN TransactionDate IS NULL THEN 1 ELSE 0 END) AS Null_TransactionDate,
  SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS Null_Amount,
  SUM(CASE WHEN PaymentType IS NULL THEN 1 ELSE 0 END) AS Null_PaymentType,
  SUM(CASE WHEN IsFraud IS NULL THEN 1 ELSE 0 END) AS Null_IsFraud
FROM Transactions;

--See Unique Values
SELECT DISTINCT Region FROM Customers;
SELECT DISTINCT Category FROM Merchants;
SELECT DISTINCT PaymentType FROM Transactions;

--Step 3 : Exploratory Data Analysis(EDA)
--Step 3.1: Total Revenue, Average Transaction, Total Fraud Cases
SELECT 
  COUNT(*) AS Total_Transactions,
  SUM(Amount) AS Total_Revenue,
  AVG(Amount) AS Avg_Transaction_Value,
  SUM(CAST(IsFraud AS INT)) AS Total_Fraud_Transactions
FROM Transactions;

--Step 3.2: Revenue by Region 
SELECT 
  C.Region,
  COUNT(T.TransactionID) AS Total_Transactions,
  SUM(T.Amount) AS Total_Revenue
FROM Transactions T
JOIN Customers C ON T.CustomerID = C.CustomerID
GROUP BY C.Region
ORDER BY Total_Revenue DESC;

--Step 3.3: Fraud Count by Region
SELECT 
  C.Region,
  COUNT(*) AS Total_Transactions,
  SUM(CAST(T.IsFraud AS INT)) AS Fraud_Transactions
FROM Transactions T
JOIN Customers C ON T.CustomerID = C.CustomerID
GROUP BY C.Region
ORDER BY Fraud_Transactions DESC;

--Step 3.4: Revenue by Merchant Category
SELECT 
  M.Category,
  COUNT(T.TransactionID) AS Total_Transactions,
  SUM(T.Amount) AS Total_Revenue
FROM Transactions T
JOIN Merchants M ON T.MerchantID = M.MerchantID
GROUP BY M.Category
ORDER BY Total_Revenue DESC;

--Step 3.5: Top 5 Customers by Spending
SELECT TOP 5
  T.CustomerID,
  SUM(T.Amount) AS Total_Spent
FROM Transactions T
GROUP BY T.CustomerID
ORDER BY Total_Spent DESC;

--Step 3.6: Fraud Pattern Analysis
--Step 3.6.1: Fraud by Payment Type
SELECT 
  PaymentType,
  COUNT(*) AS Total_Transactions,
  SUM(CAST(IsFraud AS INT)) AS Fraud_Count
FROM Transactions
GROUP BY PaymentType
ORDER BY Fraud_Count DESC;

--Step 3.6.2: Fraud by Merchant Categoery
SELECT 
  M.Category,
  COUNT(*) AS Total_Transactions,
  SUM(CAST(T.IsFraud AS INT)) AS Fraud_Count
FROM Transactions T
JOIN Merchants M ON T.MerchantID = M.MerchantID
GROUP BY M.Category
ORDER BY Fraud_Count DESC;

--Step 3.6.3: Top Cities by Number of Fraud Transactions
SELECT 
  M.City,
  COUNT(*) AS Total_Transactions,
  SUM(CAST(T.IsFraud AS INT)) AS Fraud_Count
FROM Transactions T
JOIN Merchants M ON T.MerchantID = M.MerchantID
GROUP BY M.City
ORDER BY Fraud_Count DESC;

--Step 3.6.4: Fraud % by Region 
SELECT 
  C.Region,
  COUNT(*) AS Total_Transactions,
  SUM(CAST(T.IsFraud AS INT)) AS Fraud_Transactions,
  CAST(SUM(CAST(T.IsFraud AS FLOAT)) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Fraud_Percentage
FROM Transactions T
JOIN Customers C ON T.CustomerID = C.CustomerID
GROUP BY C.Region
ORDER BY Fraud_Percentage DESC;

-- ===========================================
-- 📊 Final Project Summary (See full insights in .txt file)
-- Total Transactions: 7,500 | Total Revenue: ₹19.15 Cr
-- Average Order Value: ₹25,540 | Fraud Cases: 364
-- Highest Revenue Region: East (₹5.15 Cr)
-- Top Category: Beauty | Top Customer: CUST0387
-- For full business & fraud insights → check: Retail_Insights_with_Fraud_Analysis_Priya_Dutta.txt
-- ===========================================










