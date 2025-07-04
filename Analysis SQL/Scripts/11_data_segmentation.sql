/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/

with product_segment as (
	select
		product_key
		, product_name
		, cost
		, case	
			when cost < 100 then 'Below 100'
			when cost >= 100 and cost < 500 then '100-500'
			when cost > 500 and cost < 1000 then '500-1000'
			else 'Above 1000'
		end as cost_range
	from gold.dim_products
)
select 
	cost_range
	, count(cost) as total_product
from product_segment
group by cost_range
order by count(cost) desc;


/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

with add_total_sales as (
	select 
		c.customer_key
		, sum(sales_amount) as total_sales
		, datediff(month, min(order_date), max(order_date)) lifespan
	from gold.fact_sales f
	left join gold.dim_customers  c
		on f.customer_key = c.customer_key
	group by
		c.customer_key
)
, segment_customer as (
	select
		customer_key
		, lifespan
		, case 
            when lifespan >= 12 AND total_sales > 5000 then 'VIP'
            when lifespan >= 12 AND total_sales <= 5000 then 'Regular'
            else 'New'
        end as customer_segment
	from add_total_sales
	where lifespan is not null
)
select 
	customer_segment
	, count(customer_key) as totalCustomer
from segment_customer
group by customer_segment
order by count(customer_key) desc;

