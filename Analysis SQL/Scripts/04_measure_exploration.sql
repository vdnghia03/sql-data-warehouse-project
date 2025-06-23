/*
=========================================
Measures Exploration
=========================================
Purpose
	- To caculate aggregated metrics to quick insight
	- To identify overall trends or spot anomalies.

SQL Function:
	- COUNT(), SUM(), AVG()
==========================================
*/

-- Find the total sales
select 
	sum(sales_amount) total_sales
from gold.fact_sales;

-- Find how many item are sold
select 
	sum(quantity) total_quantity
from gold.fact_sales;

-- Find the average selling price
select
	avg(price) avg_price
from gold.fact_sales;

-- Find the total number of order
select 
	count(order_number) total_order_number
from gold.fact_sales

select
	count(distinct(order_number)) distinct_order_number
from gold.fact_sales

-- Find the total number of product
select
	count(product_number) total_products
from gold.dim_products;

-- Find the total number of customer
select 
	count(customer_key) total_customer
from gold.dim_customers

-- Find the total number of customers that has placed an order
select 
	count(distinct(customer_key)) total_customer_order
from gold.fact_sales

-- Generate a Report that shows all key metrics of the business

select 'Total Sale' measure_name, sum(sales_amount) as measure_value from gold.fact_sales
union all
select 'Total Quantity', sum(quantity) from gold.fact_sales
union all
select 'Average Price', avg(price) FROM gold.fact_sales
union all
select 'Total Order', count(order_number) from gold.fact_sales
union all
select 'Total Product', count(product_name) from gold.dim_products
union all
select 'Total Customer', count(customer_key) from gold.dim_customers;

