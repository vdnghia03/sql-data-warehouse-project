/*
===========================================
  Quality Check Gold
===========================================
Script Purpose:
     This script performs quality checks to validate the integrity, consistency and 
    accuracy of the Gold Layer. These checks ensure:
     - Add suggorate key for dim dimension unique and easily connect with fact table
     - With dim table, integrity columns most suitable for use dimension
     - Referential integrtity between fact and dimension tables
     - Validation of relationships in the

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===========================================
*/

-- ===============================
-- Check gold.dim_customers
-- ==============================

-- Check for unique ID customer_key in gold.dim_customers
-- Expectation : None

SELECT 
  customer_key
  , COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Check gold.dim_products
-- ====================================================================

-- Check for unique ID product_key in gold.dim_products
-- Expectation: None
SELECT
  product_key
, COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Check 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions

SELECT 
  *
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS cu
ON fs.customer_key = cu.customer_key
LEFT JOIN gold.dim_products AS pr
ON fs.product_key = pr.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL 
