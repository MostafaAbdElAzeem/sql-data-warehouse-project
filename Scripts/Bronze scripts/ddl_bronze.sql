/*
-----------------------------------
Creating Bronze layer
-----------------------------------
Purpose:
	- This layer involves moving data as it is to tables
	- Creating bronze tables for ERP and CRM Data

	- For ERP :	- cust_info 
				- prd_info
				- sales_details
	- For CRM :
				- cust_az12
				- loc_a101
				- px_cat_g1v2

*/

--Creating CRM tables

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    drop table bronze.crm_cust_info;
GO
CREATE TABLE bronze.crm_cust_info (
	cst_id				int ,
	cst_key				varchar(50),
	cst_firstname		varchar(50),
	cst_lastname		varchar(50),
	cst_marital_status	varchar(50),
	cst_gndr			varchar(50),
	cst_create_date		varchar(50)
    );
GO


IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    drop table bronze.crm_prd_info;
GO
CREATE TABLE bronze.crm_prd_info(
	prd_id			int,
	prd_key			varchar(50),
	prd_nm			varchar(50),
	prd_cost		int,
	prd_line		varchar(50),
	prd_start_dt	date,
	prd_end_dt		date	);
Go

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    drop table bronze.crm_sales_details;
GO
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num			varchar(50),
	sls_prd_key			varchar(50),
	sls_cust_id			int,		
	sls_order_dt		int,
	sls_ship_dt			int,	
	sls_due_dt			int,
	sls_sales			int,
	sls_quantity		int,
	sls_price			int	
	);
Go

--Creating ERP tables

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    drop table bronze.erp_cust_az12;
GO
CREATE TABLE bronze.erp_cust_az12(
	cid		varchar(50),
	bdate	date,
	gen		varchar(50));
GO


IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    drop table bronze.erp_loc_a101;
GO
CREATE TABLE bronze.erp_loc_a101(
	cid		varchar(50),
	cntry	varchar(50)	);
GO


IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    drop table bronze.erp_px_cat_g1v2;
GO
CREATE TABLE bronze.erp_px_cat_g1v2(
	id				varchar(50),
	cat				varchar(50),
	subcat			varchar(50),
	maintenance		varchar(50) );
GO

