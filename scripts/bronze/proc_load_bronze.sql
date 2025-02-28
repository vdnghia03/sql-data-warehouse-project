
/*
=======================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=======================================================
Script Purpose:
	This store procedure load data into the 'bronze' schema from external CSV files
	This performs the following actions:
	- Truncates the bronze tables before loading data
	- Uses the 'BULK INSERT' command to load data from CSV files to bronze tables.

Parameters:
	None.
		This stored procedure does not accepts any parameters or return any values

Usage Example 
	EXEC bronze.load_bronze;
*/


use DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	-- Declare time variable to write log
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	-- Try: Test error
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT '============================';
		PRINT 'Loading Bronze Layer';
		PRINT '============================';

		PRINT '============================';
		PRINT 'Loading CRM Tables'
		PRINT '============================';
	
	-- bronze.crm_cust_info
	SET @start_time = GETDATE();
		
		-- Truncate Table
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		-- Insert Table Using BULK INSERT
		PRINT '>> Insert Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info 
		FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'second';
		PRINT '>> --------------------';

	-- bronze.crm_prd_info
	SET @start_time = GETDATE();
		
		-- Truncate Table
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		-- Insert Table Using BULK INSERT
		PRINT '>> Insert Data Into: bronzo.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'second';
		PRINT '>> ---------------------';
	
	-- bronze.crm_sales_details
	SET @start_time = GETDATE();
		
		-- Truncate Table
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		-- Insert Table Using BULK INSERT
		PRINT '>> Insert Data Into: bronzo.crm_prd_info';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'second';
		PRINT '>> ---------------------';

		PRINT '============================';
		PRINT 'Loading CRM Tables'
		PRINT '============================';
	
	-- bronze.erp_cust_az12
	SET @start_time = GETDATE();

		-- Truncate Table
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		-- Insert Table Using BULK INSERT
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'second';
		PRINT '>> ---------------------';

	-- bronze.erp_loc_a101
	SET @start_time = GETDATE();

		-- Truncate Table
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		-- Insert Table Using BULK INSERT
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'second';
		PRINT '>> ---------------------';

	-- bronze.erp_loc_a101
	SET @start_time = GETDATE();

		-- Truncate Table
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		-- Insert Table Using BULK INSERT
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2
			, FIELDTERMINATOR = ','
			, TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'second';
		PRINT '>> ---------------------';

		SET @batch_end_time = GETDATE();
		PRINT '==============================='
		PRINT '>> Loading Bronze Layer is Complete';

	PRINT '		-Total Loading Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'second';
		PRINT '==============================='

	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH

END
