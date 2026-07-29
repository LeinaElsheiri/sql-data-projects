/*
====================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
====================================================================

Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncate the bronze tables before loading data.
    - Uses the 'BULK INSERT' command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;

====================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN 
	declare @start_time DATETIME, @end_time DATETIME , @first_whole_time DATETIME,@second_whole_time DATETIME;
	BEGIN TRY
		-- we need to add all of these stuff for all tables, but i am lazy.
		print '================================';
		print 'Loading a Bronze layer';
		print '================================';
		print '--------------------------------';
		print 'Loading CRM tables';
		print '--------------------------------';

		SET @start_time= GETDATE();

		print '>> Truncating Table:  [bronze].[crm_cust_info]';
		-- 1) 
		set @first_whole_time = GETDATE();
		TRUNCATE TABLE [bronze].[crm_cust_info];
		-- IF YOU LOAD YOUR DATA AGAIN, THERE WILL BE DUPLICATE, SO WE WILL DO TRUNCATE , THEN LOAD.
		print '>> Inserting Data into :  [bronze].[crm_cust_info]';
		BULK INSERT [bronze].[crm_cust_info]
		-- the full location of file that we trying to load into this table 
		FROM 'C:\Users\Leina\OneDrive\Desktop\cust_info.csv'
		-- how to handle our file
		with (
			firstrow=2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time= GETDATE();
		print '>>> Load Duration: '+CAST( DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		print '----------------------------------'

		-- TEST THE QUILTY OF YOUR TABLE 
		-- cheack if the data in corret column + do we have data 
		SELECT COUNT(*) FROM bronze.crm_cust_info;


		-- THIS CALLED FULL LOAD.
		------------------------------------------------------------------------------
		-- 2)

		TRUNCATE TABLE [bronze].[crm_prd_info];
		-- IF YOU LOAD YOUR DATA AGAIN, THERE WILL BE DUPLICATE, SO WE WILL DO TRUNCATE , THEN LOAD.
		BULK INSERT [bronze].[crm_prd_info]
		-- the full location of file that we trying to load into this table 
		FROM 'C:\Users\Leina\OneDrive\Desktop\prd_info.csv'
		-- how to handle our file
		with (
			firstrow=2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		-- TEST THE QUILTY OF YOUR TABLE 
		-- cheack if the data in corret column + do we have data 
		SELECT COUNT(*) FROM bronze.crm_prd_info;

		------------------------------------------------------------------------------
		-- 3)

		TRUNCATE TABLE [bronze].[crm_sales_details];
		-- IF YOU LOAD YOUR DATA AGAIN, THERE WILL BE DUPLICATE, SO WE WILL DO TRUNCATE , THEN LOAD.
		BULK INSERT [bronze].[crm_sales_details]
		-- the full location of file that we trying to load into this table 
		FROM 'C:\Users\Leina\OneDrive\Desktop\sales_details.csv'
		-- how to handle our file
		with (
			firstrow=2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		-- TEST THE QUILTY OF YOUR TABLE 
		-- cheack if the data in corret column + do we have data 
		SELECT COUNT(*) FROM bronze.crm_sales_details;

		------------------------------------------------------------------------------
		print '--------------------------------';
		print 'Loading ERP tables';
		print '--------------------------------';
		-- 4)

		TRUNCATE TABLE [bronze].[erp_cust_az12];
		-- IF YOU LOAD YOUR DATA AGAIN, THERE WILL BE DUPLICATE, SO WE WILL DO TRUNCATE , THEN LOAD.
		BULK INSERT [bronze].[erp_cust_az12]
		-- the full location of file that we trying to load into this table 
		FROM 'C:\Users\Leina\OneDrive\Desktop\CUST_AZ12.csv'
		-- how to handle our file
		with (
			firstrow=2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		-- TEST THE QUILTY OF YOUR TABLE 
		-- cheack if the data in corret column + do we have data 
		SELECT COUNT(*) FROM [bronze].[erp_cust_az12];

		------------------------------------------------------------------------------
		-- 5)

		TRUNCATE TABLE [bronze].[erp_loc_a101];
		-- IF YOU LOAD YOUR DATA AGAIN, THERE WILL BE DUPLICATE, SO WE WILL DO TRUNCATE , THEN LOAD.
		BULK INSERT [bronze].[erp_loc_a101]
		-- the full location of file that we trying to load into this table 
		FROM 'C:\Users\Leina\OneDrive\Desktop\LOC_A101.csv'
		-- how to handle our file
		with (
			firstrow=2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		-- TEST THE QUILTY OF YOUR TABLE 
		-- cheack if the data in corret column + do we have data 
		SELECT COUNT(*) FROM [bronze].[erp_loc_a101];





		------------------------------------------------------------------------------
		-- 6)

		TRUNCATE TABLE [bronze].[erp_px_cat_g1v2];
		-- IF YOU LOAD YOUR DATA AGAIN, THERE WILL BE DUPLICATE, SO WE WILL DO TRUNCATE , THEN LOAD.
		BULK INSERT [bronze].[erp_px_cat_g1v2]
		-- the full location of file that we trying to load into this table 
		FROM 'C:\Users\Leina\OneDrive\Desktop\PX_CAT_G1V2.csv'
		-- how to handle our file
		with (
			firstrow=2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		-- TEST THE QUILTY OF YOUR TABLE 
		-- cheack if the data in corret column + do we have data 
		SELECT COUNT(*) FROM [bronze].[erp_px_cat_g1v2];
		set @second_whole_time = GETDATE();
		print '>>> Load whole Duration for bronze layer: '+CAST( DATEDIFF(second,@first_whole_time,@second_whole_time) AS NVARCHAR) + ' seconds';
		print '----------------------------------'


	END TRY
	BEGIN CATCH
			-- maybe creating loging table , and add messeages to it.
		PRINT '==========================================';
		PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
		PRINT 'Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR(10));
		PRINT '==========================================';
	END CATCH
END;
----------------------------------------------------------------------------------------------------------------
-- this script is frequantly used , so we will put it in stored prosdure
-- when you write stored procedure , take care of your messages
-- the time of inserting data are very fast , because loading is very fast, but in actual real world , we have differnet services , so it may take along of time.
-- how took it take to load the whole bronze layer??
-------------------------------------------------------------------------------

EXEC [bronze].[load_bronze];
