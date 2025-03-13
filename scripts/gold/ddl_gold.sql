/*
===================================================================
Create DDL gold - Dimension and Fact
===================================================================
Script Purpose:
	This scripts creates view for Gold Layer in Data Warehouse
	The Gold Layer represents the final dimension and Fact Table (Star Schema)

	Each View perform transformations and combines data from the Silver Layer
	to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===================================================================
*/


-- ===========================================================================
-- Create Dimension : gold.dim_customers
-- ===========================================================================
CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key -- Suggorate Key
	, ci.cst_id AS customer_id
	, ci.cst_key AS customer_number
	, ci.cst_firstname AS first_name
	, ci.cst_lastname AS last_name
	, la.cntry AS country
	, ci.cst_marital_status AS marital_status
	, CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr 
		ELSE COALESCE(ca.gen, 'n/a')
	END AS gender -- CRM is the master for gender info - Data integration
	, ca.bdate AS birthday
	, ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON		ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON      ci.cst_key = la.cid


-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
CREATE VIEW gold.dim_products AS 
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key
	, pn.prd_id AS product_id
	, pn.prd_key AS product_number
	, pn.prd_nm AS product_name
	, pn.cat_id AS category_id
	, pc.cat AS category
	, pc.subcat AS subcategory
	, pc.maintenance AS maintenance	
	, pn.prd_cost AS cost
	, pn.prd_line AS product_line
	, pn.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filter Out all historical Data

	
-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number
	, pr.product_key
	, cu.customer_key
	, sd.sls_order_dt AS order_date
	, sd.sls_ship_dt AS ship_date
	, sd.sls_due_dt AS due_date
	, sd.sls_sales AS sales_amount
	, sd.sls_quantity AS quantity
	, sd.sls_price AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers AS cu
ON sd.sls_cust_id = cu.customer_id

