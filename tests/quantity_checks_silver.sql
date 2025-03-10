/*
============================================================================
	Quality Check Silver
============================================================================
Script Purpose:
   This script performs various quantity checks for data consistency, accuracy
and standardization across the 'silver' schema. It includes check for:
	- Null or duplicate primary key
	- Unwanted space in string fields
	- Data standardization and consistency
	- Invalid the ranges and orders.
	- Data consistency between related fields.
Usage Notes:
	- Run re-check after data loading Silver Layer.
	- Investigate and resolve any discrepancies found during the checks.
==============================================================================
*/

use DataWarehouse;

-- ============================================
--   CHECK TABLE silver.crm_cust_info
-- ============================================

-- Check For Null or Duplicates in Primary Key
-- Expected: No result

SELECT 
	cst_id
	, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL



-- Check For Unwanted Space
-- Expectation: No Result
SELECT
	cst_firstname
	FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)


-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info


SELECT * FROM silver.crm_cust_info;


--===================================
-- bronze.crm_prd_info
--===================================

-- Check a Nulls or Duplicates in Primary Key
-- Expected : No result

SELECT
	prd_id
	, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


-- Check For Unwanted Space
-- Expected: No Result

SELECT 
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for Nulls or Negative Numbers
-- Expected : No Result
SELECT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


-- Check for Consitency & Standardization
SELECT DISTINCT prd_line
FROM silver.crm_prd_info


-- ============================================
--   CHECK TABLE silver.crm_sales_details
-- ============================================

-- Check Unwanted Space
-- Expected: No result
SELECT
	sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

-- Check Forein Key is issue
-- Expected: No Result
SELECT
	sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT
	sls_cust_id
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)

-- Check Invalid Dates
-- Expectation: No Invalid date
SELECT 
	NULLIF(sls_ship_dt,0) AS sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0  
OR LEN(sls_ship_dt) < 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101

-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
-- Expectation: No Results
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Sales = Quantity * Price
-- Expectation: No Results

SELECT DISTINCT
	sls_sales
	, sls_quantity
	, sls_price
FROM silver.crm_sales_details
WHERE
	sls_sales != sls_quantity * sls_price
	OR sls_sales <= 0 OR sls_sales IS NULL
	OR sls_quantity <= 0 OR sls_quantity IS NULL
	OR sls_price <= 0 OR sls_price IS NULL
ORDER BY sls_sales, sls_quantity, sls_price

-- ============================================
--   CHECK TABLE silver.erp_cust_az12
-- ============================================

-- Check Invalid Date
SELECT DISTINCT
	bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Check consistency

SELECT DISTINCT
	gen
FROM silver.erp_cust_az12
-- ============================================
--   CHECK TABLE silver.erp_loc_a101
-- ============================================

-- Check Forein Key
-- Expectation: No Result
SELECT DISTINCT
	REPLACE(TRIM(cid), '-','') AS cid
	, cntry
FROM bronze.erp_loc_a101
-- WHERE REPLACE(TRIM(cid), '-','') NOT IN
-- (SELECT cst_key
-- FROM silver.crm_cust_info)

-- Check consistency & normalization
SELECT DISTINCT
	cntry
FROM silver.erp_loc_a101

-- ============================================
--   CHECK TABLE silver.erp_px_cat_g1v2
-- ============================================
SELECT *
FROM bronze.erp_px_cat_g1v2

-- Check Foreign Key
SELECT
	id
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN
(
	SELECT cat_id FROM silver.crm_prd_info
)

-- Check Unwanted Space
SELECT
	id
	, cat
	, subcat
	, maintenance
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR  maintenance != TRIM(maintenance) OR subcat != TRIM(subcat)

-- Check Consistency

SELECT DISTINCT
	maintenance
FROM bronze.erp_px_cat_g1v2

