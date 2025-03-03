/*
=======================================================
 QUALITY CHECK FOR ALL TABLE OF BRONZE
=======================================================
Script Purpose:
  - Check for table ....
  - .....

*/



-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result

SELECT 
  cst_id
  , COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check For Unwanted Space
-- Expectation: No Result

SELECT
  cst_firstname
  FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT
  cst_lastname
  FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info

