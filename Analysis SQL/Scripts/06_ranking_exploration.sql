/*
==================================================
Ranking Exploration
==================================================
Purpose:
	- To rank item (e.g., products, customer) base on performance or other metrics
	- To identify top performer or laggards

SQL Function Usage:
	- Window Ranking Function: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
	- Clauses: GROUP BY, ORDER BY

==================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking not use window function
select top 5
	p.product_name
	, sum(f.sales_amount) revenueByProduct
from gold.fact_sales f
left join gold.dim_products p
	on f.product_key = p.product_key
group by p.product_name
order by sum(f.sales_amount) desc;

-- Complex but Flexibly Ranking Using Window Functions
select 
	product_name
	, revenueByProduct
from (
	select
		p.product_name
		, sum(f.sales_amount) revenueByProduct
		, rank() over(order by sum(f.sales_amount) desc) as rankRevenue
	from gold.fact_sales f
	left join gold.dim_products p
		on f.product_key = p.product_key
	group by p.product_name
) as ranked_products
where rankRevenue <= 5;


-- What are the 5 worst-performing products in terms of sales?
select top 5
	p.product_name
	, sum(f.sales_amount) revenueByProduct
from gold.fact_sales f
left join gold.dim_products p
	on f.product_key = p.product_key
group by p.product_name
order by sum(f.sales_amount);

-- Find the top 10 customers who have generated the highest revenue

select top 10
	c.customer_key
	, c.first_name
	, c.last_name
	, sum(f.sales_amount) revenueByCustomer
from gold.fact_sales f
left join gold.dim_customers c
	on f.customer_key = c.customer_key
group by 
	c.customer_key
	, c.first_name
	, c.last_name
order by sum(f.sales_amount) desc;

-- Using Ranking
select *
from (
	select
		c.customer_key
		, c.first_name
		, c.last_name
		, sum(f.sales_amount) revenueByCustomer
		, rank() over(order by sum(f.sales_amount) desc) as RankTopCustomer
	from gold.fact_sales f
	left join gold.dim_customers c
		on f.customer_key = c.customer_key
	group by 
		c.customer_key
		, c.first_name
		, c.last_name
) as Ranked_Customers
where RankTopCustomer <= 10


-- The 3 customers with the fewest orders placed
select top 3
	c.customer_key
	, c.first_name
	, c.last_name
	, count(distinct(order_number)) as numberOrderByCustomer
from gold.fact_sales f
left join gold.dim_customers c
	on f.customer_key = c.customer_key
group by 
	c.customer_key
	, c.first_name
	, c.last_name
order by count(distinct(order_number));



