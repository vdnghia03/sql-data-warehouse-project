/*
========================================================
Part to Whole Analysis
========================================================
Purpose:
	- To compare performance or metrics across dimension or time periods
	- To evaluate difference between category
	- Useful for A/B testing or regional comparisons.

SQL Function Used:
	- SUM(), AVG(): Aggregates values for comparison
	- Window Function: SUM(), OVER() for total calculation
========================================================
*/

-- Which categories contribute the most to overall sales?

with category_contribute as (
	select 
		p.category
		, sum(f.sales_amount) total_sales
	from gold.fact_sales f
	left join gold.dim_products p
		on f.product_key = p.product_key
	group by p.category
)
select
	category
	, total_sales
	, sum(total_sales) over() as overall_sales
	, round(cast(total_sales as float) / sum(total_sales) over() * 100,2) as percentage_of_total
from category_contribute

