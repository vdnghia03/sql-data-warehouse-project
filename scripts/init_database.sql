/*
==================================================================
Create Database and Schemas
==================================================================
Script Purpose:
  This cript create a new database name 'DataWarehouse' after checking if it already exists.
  If database exists, it is dropped and recreated. Additionally, the script sets up three schemas
  within the database: 'bronze', 'silver' and 'gold'.

Warning:
  Running script will drop the entire 'DataWarehouse' database if exists.
  All data in the database will be permanently deleted. Proceed with caution
  and ensure you have proper backups before running this scripts.

*/

USE master;

-- Drop and recreate the 'DataWarehouse' database 
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse;
END;
GO


-- CREATE DATABASE 'Data Warehouse'
CREATE DATABASE DataWarehouse;
GO
  
USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO
  
CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO

