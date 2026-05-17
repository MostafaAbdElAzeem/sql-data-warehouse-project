/*
---------------------------------------
Quality Check : Silver Layer
---------------------------------------
Purpose :
		- Applying checks on bronze layer tables to ensure data 
		  is cleaned and consistent. 
		- It includes checks for:
				- Null or duplicate primary keys.
				- Unwanted spaces in string fields.
				- Data standardization and consistency.
				- Invalid date ranges and orders.
				- Data consistency between related fields.

*/


---------------------------------------------
-- Quality Check : CRM Tables
---------------------------------------------

-- ** 1- Checking crm_cust_info **
select * from silver.crm_cust_info 

-- Checking for duplicates or nulls
select cst_id, COUNT(*)
from silver.crm_cust_info 
group by  cst_id
having COUNT(*)>1 or cst_id is null 

-- Checking for columns include unwanted spaces
select * 
from silver.crm_cust_info 
where cst_firstname != trim(cst_firstname) 
	  or cst_lastname != trim(cst_lastname)
	   
-- Data Standardization & Consistency
select distinct(cst_marital_status)
from silver.crm_cust_info
select distinct(cst_gndr)
from silver.crm_cust_info

 
-- ** 2- Checking crm_prd_info **

select  * from silver.crm_prd_info

-- Checking for duplicates or nulls
select prd_id, COUNT(*)
from silver.crm_prd_info 
group by  prd_id
having COUNT(*)>1 or prd_id is null 

-- Checking for columns include unwanted spaces
select * 
from silver.crm_prd_info 
where prd_key != trim(prd_key) 

-- Check for NULLs or negative values in cost
select  * 
from silver.crm_prd_info
where prd_cost is null or prd_cost <0

-- Data Standardization & Consistency
select  distinct(prd_line) 
from silver.crm_prd_info

-- Date validation
-- Start date must be < End date
select  * 
from silver.crm_prd_info
where prd_start_dt>prd_end_dt


-- ** 3- Checking crm_sales_details **
select  * from silver.crm_sales_details

-- Check for Invalid Dates
SELECT 
    NULLIF(sls_order_dt, 0) AS sls_due_dt 
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0 
    OR LEN(sls_order_dt) != 8 
    OR sls_order_dt > 20500101 
    OR sls_order_dt < 19000101;

-- Checking for Nulls
select *
from bronze.crm_sales_details
where sls_ord_num is null

-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

--Data consistency : Sales = Quantity * Price
SELECT 
	sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;








---------------------------------------------
-- Quality Check : ERP Tables
---------------------------------------------
 
 -- ** 1- Checking erp_cust_az12 **
 select * from silver.erp_cust_az12

 --Data consistency & standardization
 select distinct gen from silver.erp_cust_az12

 --Checking for valid date range
 select * from silver.erp_cust_az12
where bdate>GETDATE()

 -- 2- ** Checking erp_loc_a101 **
 select * from silver.erp_loc_a101

 -- Data consistency : cid should not contain '-' 
 select cid 
 from silver.erp_loc_a101
 where cid like '%-%'
 
 -- Data consistency & standardization
 select distinct cntry
 from silver.erp_loc_a101
 
 -- ** 3- Checking erp_px_cat_g1v2 **
 select * from silver.erp_px_cat_g1v2
 
 -- check for unwanted spaces
 select * 
 from silver.erp_px_cat_g1v2
 where id!=trim(id)
 or cat!=trim(cat)
 or subcat!=trim(subcat)
 or maintenance!=trim(maintenance)

 -- Data Consistency & Standardization
 select distinct maintenance
 from silver.erp_px_cat_g1v2

