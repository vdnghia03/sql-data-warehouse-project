
/*
==================================================
Database Exploration
==================================================
Purpose:
	- To explore the structure of database
	- To inspect the column of specific table

Table Used:
	- INFORMATION_SCHEMA.TABLES
	- INFOMATION_SCHEMA.COLUMNS

*/


-- Explore all object in the database
select * from INFORMATION_SCHEMA.TABLES;

-- Explore all Column in the database
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'dim_customers';

select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'dim_products';
