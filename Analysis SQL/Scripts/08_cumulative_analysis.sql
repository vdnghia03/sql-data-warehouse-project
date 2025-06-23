/*
================================================
Cumulative Analysis
================================================
Purpose:
	- To calculate running totals or moving average for the key metric
	- To track performance over time cumulatively
	- Useful for growth analysis or identifying long-term trends.

SQL Window function
	- SUM(), OVER(), AVG(), OVER()
================================================
*/

-- Calculate the total sales per month
-- and running total of sales over time

select
	order_date
	, total_sales
	-- Default window frame: rows between unbounded preceding and current row
	, sum(total_sales) over(order by order_date) as running_total_sales
	, avg(avg_price) over(order by order_date) as moving_avg_price
from (
	select 
		datetrunc(year,order_date) as order_date
		, sum(sales_amount) as total_sales
		, avg(price) as avg_price
	from gold.fact_sales
	where order_date is not null
	group by datetrunc(year,order_date)
) t
