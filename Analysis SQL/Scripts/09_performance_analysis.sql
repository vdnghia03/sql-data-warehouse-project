
/*
==========================================================
Performance Analysis
==========================================================
Purpose:
	- To measure the performance of products, customer, or region over time
	- For benchmarking and identifying high-performing entities
	- To track yearly trends and growth

SQL Function Used:
	- LAG()
	- AVG() OVER()
	- CASE()
==========================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

with yearly_product_sales as (
	select
		year(f.order_date) as order_year
		, p.product_name
		, sum(f.sales_amount) as current_sales
	from gold.fact_sales f
	left join gold.dim_products p
		on f.product_key = p.product_key
	where product_name is not null and year(f.order_date) is not null
	group by year(f.order_date), p.product_name
)
select 
	order_year
	, product_name
	, current_sales
	, avg(current_sales) over(partition by product_name) avg_sales
	, (current_sales -  avg(current_sales) over(partition by product_name)) as diff_avg 
	, case 
		when (current_sales -  avg(current_sales) over(partition by product_name)) < 0 then 'Below Avg'
		when (current_sales -  avg(current_sales) over(partition by product_name)) > 0 then 'Above Avg'
		else 'Equal Avg'
	end as avg_change
	-- Year over year analysis
	, lag(current_sales) over(partition by product_name order by order_year) as py_sales
	, (current_sales - lag(current_sales) over(partition by product_name order by order_year)) as diff_py
	, case
		when (current_sales - lag(current_sales) over(partition by product_name order by order_year)) > 0 then 'Increase'
		when (current_sales - lag(current_sales) over(partition by product_name order by order_year)) < 0 then 'Decrease'
		else 'No Change'
	end as py_change
from yearly_product_sales
