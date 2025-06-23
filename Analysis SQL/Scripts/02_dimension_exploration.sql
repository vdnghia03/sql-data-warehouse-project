
/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
	- To explore structure of the dimension table

SQL Usage:
	- DISTINCT
	- ORDER BY
=============================================================================
*/

-- Explore all country our customer come from
select distinct country from gold.dim_customers


-- Explore all categories "The major Divisions
select distinct category, subcategory, product_name from gold.dim_products
order by 1,2,3;
