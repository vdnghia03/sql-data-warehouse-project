/*
=================================================================
CREATE SILVER LAYER WITH TRANSFORMATION
=================================================================
Script Purpose:
  - Solution of issue data quality in many Tables
  -................
*/

SELECT 
	cst_id
	, cst_key
	, TRIM(cst_firstname) AS cst_firstname
	, TRIM(cst_lastname) AS cst_lastname
	, CASE 
  		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
  		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
  		ELSE 'n/a'
	END cst_marital_status
	, CASE
  		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
  		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
  		ELSE 'n/a'
	END cst_gndr
	,cst_create_date
FROM (
	SELECT 
	*
	, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
) AS T
WHERE T.flag_last = 1

