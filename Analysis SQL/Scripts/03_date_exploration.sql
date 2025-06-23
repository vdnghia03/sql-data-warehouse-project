/*
================================================
DATE EXPLORATION
==================================================
Purpose:
	- To determine the temporal boudaries of key data point
	- To understand the range of historical data

SQL Usage:
	- MIN() , MAX(), DATEDIFF()

*/

-- Determine the first and last order date and the total duration in months

select
	min(order_date) first_order_date
	, max(order_date) last_order_date
	, datediff(month, min(order_date), max(order_date)) order_range_month
from gold.fact_sales;



-- Find the youngest and oldest customer
select 
	min(birthdate) oldest_customer
	, datediff(year, min(birthdate), GETDATE()) age_oldest
	, max(birthdate) yongest_customer
	, datediff(year, max(birthdate), GETDATE()) age_youngest
from gold.dim_customers
