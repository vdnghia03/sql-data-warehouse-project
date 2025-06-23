/*
============================================
CHANGE OVER TIME ANALYSIS
============================================
Purpose:
	- To track a trends, growth and change in key metrics over time.
	- For time series analysis and identifying seasonality.
	- To measure growth or decline over specific periods.

SQL Function Usage:
	- Date Function: DATEPART(), DATENAME(), DATETRUNC(), FORMAT(), CAST()
	- Aggregation Function: SUM(), COUNT(), AVG()

============================================
*/

-- Analyse sales performance over time

-- Quick Date Functions
select
	year(order_date) order_year
	, month(order_date) order_month
	, sum(sales_amount) total_sales
	, count(distinct(customer_key)) total_customer
	, sum(quantity) total_quantity
from gold.fact_sales
where order_date is not null
group by year(order_date), month(order_date)
order by year(order_date), month(order_date);

-- DATETRUNC
select
	datetrunc(month, order_date) order_month
	, sum(sales_amount) total_sales
	, count(distinct(customer_key)) total_customer
	, sum(quantity) total_quantity
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_date)
order by datetrunc(month, order_date);


-- FORMAT
select
	format(order_date, 'yyyy-MMM') order_date
	, sum(sales_amount) total_sales
	, count(distinct(customer_key)) total_customer
	, sum(quantity) total_quantity
from gold.fact_sales
where order_date is not null
group by format(order_date, 'yyyy-MMM')
order by format(order_date, 'yyyy-MMM');
