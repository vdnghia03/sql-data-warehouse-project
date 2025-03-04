
/*
============================================
	CHECK BRONZE LAYER
============================================
Script Purpose:
 - Check All Table to Transformation at Silver Layer
*/

use DataWarehouse;

-----------------------------
-- bronze.crm_cust_info
-----------------------------

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


-----------------------------
-- bronze.crm_prd_info
-----------------------------

-- Check a Nulls or Duplicates in Primary Key
-- Expected : No result

SELECT
	prd_id
	, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


-- Check For Unwanted Space
-- Expected: No Result

SELECT 
	prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for Nulls or Negative Numbers
-- Expected : No Result
SELECT 
	prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


-- Check for Consitency & Standardization
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- Check for Invalid Date Object
SELECT
	prd_id
	, prd_key
	, prd_nm
	, prd_start_dt
	, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1  AS prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')
