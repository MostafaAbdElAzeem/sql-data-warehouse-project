/*
---------------------------------------
Stored Procedure : Bronze Layer
---------------------------------------
Purpose :
		- Creating stored procedure to load data from source to Bronze Layer
		- Soucre is csv files
		- We will make a full load 
		- The approch use is : 
						- Truncate tables data
						- Bulk insert from source 	
Parameters:
    - None 

Usage Example:
		- EXEC bronze.load_bronze;

*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

	--Those variables will be used to calac the whole process time
	declare @batch_start_time DATETIME, @batch_end_time DATETIME; 
	--Those variables will be used to calac each process time
	declare @start_time DATETIME, @end_time DATETIME; 
	
	--Try & Catch
	begin try
		print '=================================================';
		print 'Loading data into bronze layer';
		print '=================================================';

		set @batch_start_time=getdate();
		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		set @start_time=getdate();
		PRINT '-> Truncating data from table : bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;
		PRINT '-> Inserting data into table :  bronze.crm_cust_info';
		bulk insert bronze.crm_cust_info
		from 'F:\Data Engineering & Analysis\Data with Baraa - SQL Data Warehouse Portfolio Project\DWH\MyWork\datasets\source_crm\cust_info.csv'
		with (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
				);

		set @end_time=getdate();
		print 'Load complete';
		print 'Duration : '+
				convert(varchar(50),DATEDIFF(second, @start_time, @end_time));
		print'---------------------------';
		
		set @start_time=getdate();
		PRINT '-> Truncating data from table : bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;
		PRINT '-> Inserting data into table :  bronze.crm_prd_info';
		bulk insert bronze.crm_prd_info
		from 'F:\Data Engineering & Analysis\Data with Baraa - SQL Data Warehouse Portfolio Project\DWH\MyWork\datasets\source_crm\prd_info.csv'
		with (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
				);

		set @end_time=getdate();
		print 'Load complete';
		print 'Duration : '+
				convert(varchar(50),DATEDIFF(second, @start_time, @end_time));
		print'---------------------------';
		
		set @start_time=getdate();
		PRINT '-> Truncating data from table : bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;
		PRINT '-> Inserting data into table :  bronze.crm_sales_details';
		bulk insert bronze.crm_sales_details
		from 'F:\Data Engineering & Analysis\Data with Baraa - SQL Data Warehouse Portfolio Project\DWH\MyWork\datasets\source_crm\sales_details.csv'
		with (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
				);

		set @end_time=getdate();
		print 'Load complete';
		print 'Duration : '+
				convert(varchar(50),DATEDIFF(second, @start_time, @end_time));
		
		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';

		set @start_time=getdate();
		PRINT '-> Truncating data from table : bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12; 
		PRINT '-> Inserting data into table :  bronze.bronze.erp_cust_az12';
		bulk insert bronze.erp_cust_az12
		from 'F:\Data Engineering & Analysis\Data with Baraa - SQL Data Warehouse Portfolio Project\DWH\MyWork\datasets\source_erp\CUST_AZ12.csv'
		with (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
				);

		set @end_time=getdate();
		print 'Load complete';
		print 'Duration : '+
				convert(varchar(50),DATEDIFF(second, @start_time, @end_time));
		print'---------------------------';
		
		set @start_time=getdate();
		PRINT '-> Truncating data from table : bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101; 
		PRINT '-> Inserting data into table :  bronze.erp_loc_a101';
		bulk insert bronze.erp_loc_a101
		from 'F:\Data Engineering & Analysis\Data with Baraa - SQL Data Warehouse Portfolio Project\DWH\MyWork\datasets\source_erp\LOC_A101.csv'
		with (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
				);

		set @end_time=getdate();
		print 'Load complete';
		print 'Duration : '+
				convert(varchar(50),DATEDIFF(second, @start_time, @end_time));
		print'---------------------------';
		
		set @start_time=getdate();
		PRINT '-> Truncating data from table : bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2; 
		PRINT '-> Inserting data into table :  bronze.erp_px_cat_g1v2';
		bulk insert bronze.erp_px_cat_g1v2
		from 'F:\Data Engineering & Analysis\Data with Baraa - SQL Data Warehouse Portfolio Project\DWH\MyWork\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK 
				);
		set @end_time=getdate();
		print 'Load complete';
		print 'Duration : '+
				convert(varchar(50),DATEDIFF(second, @start_time, @end_time));
		
		set @batch_end_time=getdate()
		PRINT '------------------------------------------------';
		PRINT 'Loading Bronze Layer succeeded ';
		print 'Total Duration : '+
					convert(varchar(50),DATEDIFF(second, @batch_start_time,@batch_end_time));
		PRINT '------------------------------------------------';


	end try
	begin catch
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message ' + ERROR_MESSAGE();
		PRINT 'Error Message ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	end catch
end


