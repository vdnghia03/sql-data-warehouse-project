/*
=================================================================
CREATE SILVER LAYER WITH TRANSFORMATION
=================================================================
Script Purpose:
  - Solution of issue data quality in many Tables
  -................
*/

use DataWarehouse;

INSERT INTO silver.crm_cust_info (
	cst_id
	, cst_key
	, cst_firstname
	, cst_lastname
	, cst_marital_status
	, cst_gndr
	, cst_create_date
)
SELECT 
	cst_id
	, cst_key
	, TRIM(cst_firstname) AS cst_firstname -- Remove unnecessary spaces
	, TRIM(cst_lastname) AS cst_lastname   -- Remove unnecessary spaces
	, CASE 
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'n/a'
	END AS cst_marital_status -- Normalize marital status values to readable format
	, CASE
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'n/a'
	END AS cst_gndr			-- Normalize gender values to readable format
	,cst_create_date
FROM (
	SELECT 
	*
	, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
) AS T
WHERE T.flag_last = 1  -- Select the most recent record for customer


INSERT INTO silver.crm_prd_info (
	prd_id
	, cat_id
	, prd_key
	, prd_nm
	, prd_cost
	, prd_line
	, prd_start_dt
	, prd_end_dt
)
SELECT
	prd_id
	, REPLACE(SUBSTRING(TRIM(prd_key), 1, 5), '-', '_') AS cat_id
	, SUBSTRING(TRIM(prd_key), 7, LEN(prd_key)) AS prd_key
	, prd_nm
	, ISNULL(prd_cost, 0) AS prd_cost
	, CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line
	, CAST(prd_start_dt AS DATE) AS prd_start_dt
	, CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info
-- WHERE SUBSTRING(prd_key, 7, LEN(prd_key)) NOT IN
-- (SELECT sls_prd_key FROM bronze.crm_sales_details)

-- WHERE REPLACE(SUBSTRING(TRIM(prd_key), 1, 5), '-', '_') NOT IN
-- 	(SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2)

INSERT INTO silver.crm_sales_details(
	sls_ord_num
	, sls_prd_key
	, sls_cust_id
	, sls_order_dt
	, sls_ship_dt
	, sls_due_dt
	, sls_sales
	, sls_quantity
	, sls_price
)
SELECT
	sls_ord_num
	, sls_prd_key
	, sls_cust_id
	, CASE 
		WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
		ELSE CAST( CAST(sls_order_dt AS VARCHAR) AS DATE ) 
	END AS sls_order_dt
	, CASE 
		WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		ELSE CAST( CAST(sls_ship_dt AS VARCHAR) AS DATE ) 
	END AS sls_ship_dt
	, CASE 
		WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
		ELSE CAST( CAST(sls_due_dt AS VARCHAR) AS DATE ) 
	END AS sls_due_dt
	, CASE 
		WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != ABS(sls_price) * sls_quantity
				THEN ABS(sls_price) * sls_quantity
		ELSE sls_sales
	END AS sls_sales  -- Recaculate sales if original value is missing or incorrect
	, sls_quantity
	, CASE 
			WHEN sls_price <= 0 OR sls_price IS NULL
					THEN sls_sales / NULLIF(sls_quantity,0)
			ELSE sls_price
	END AS sls_price -- Derive price if original value is invalid
FROM bronze.crm_sales_details

--===================================
--==================================
INSERT INTO silver.erp_cust_az12(
	cid
	, bdate
	, gen
)
SELECT 
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- Remove NAS prefix if exsist
		ELSE cid
	END AS cid
	, CASE
		WHEN bdate > GETDATE() THEN NULL -- Set birthday future is NULL
		ELSE bdate
	END AS bdate
	, CASE 
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		ELSE 'n/a'
	END AS gen -- Normalize gender value and handle unknown case
FROM bronze.erp_cust_az12


-- ===================================
-- ===================================
INSERT INTO silver.erp_loc_a101(
	cid
	, cntry
)
SELECT DISTINCT
	REPLACE(TRIM(cid), '-','') AS cid
	, CASE 
		WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		WHEN TRIM(cntry) = '' OR TRIM(cntry) IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101
