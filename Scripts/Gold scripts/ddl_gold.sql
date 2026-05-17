/*
------------------------------------------
Creating Gold Layer
------------------------------------------
Purpose:
	- This layer combines data from silver layer 
	- Creates views for fact and dimension tables
	- Fact tables :
			- fact_sales
	- Dimension tables :
			- dim_customers
			- dim_products
	- Views are created after applying some data modifications like :
						- Data integration 
						- Giving columns meaningful names
						- Reordering columns in view

------------------------------------------
*/

-- creating dimension tables

-- 1- dim_customers
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
create view gold.dim_customers as
select 
	ROW_NUMBER() over ( order by ci.cst_id )    as  'customer_key',
	ci.cst_id									as 'customer_id',
	ci.cst_key									as 'customer_number',
	ci.cst_firstname							as  'first_name',
	ci.cst_lastname								as  'last_name',
	la.cntry									as  'country',  
	ci.cst_marital_status						as  'marital_status',
	case
	when ci.cst_gndr != 'n/a' then ci.cst_gndr
	else isnull(ca.gen,'n/a')
	end											as 'gender',
	ca.bdate									as 'birth_date'
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
	on ci.cst_key=ca.cid
left join silver.erp_loc_a101 la
	on ci.cst_key=la.cid;
go

-- 2- dim_products
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO
create view gold.dim_products as 
select 
	ROW_NUMBER()over(order by prd_id)	as  'product_key',
	p.prd_id							as  'product_id',		
	p.prd_key							as 'product_number',
	p.prd_nm							as  'product_name',
	p.prd_cat							as 	'category_id',
	px.cat								as 'product_category',
	px.subcat							as 'product_subcategory',
	p.prd_line							as 'product_line',
	p.prd_cost							as 'product_cost',
	px.maintenance						as 'maintenance',
	p.prd_start_dt						as 'product_start_date'	
from silver.crm_prd_info p
left join silver.erp_px_cat_g1v2 px
	on p.prd_cat=px.id
where prd_end_dt is null

-------------------------------------------------------------------------
-- creating fact tables

-- ** fact_sales **
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  as 'order_number',
    pr.product_key  as 'product_key',
    cu.customer_key as 'customer_key',
    sd.sls_order_dt as 'order_date',
    sd.sls_ship_dt  as 'shipping_date',
    sd.sls_due_dt   as 'due_date',
    sd.sls_sales    as 'sales_amount',
    sd.sls_quantity as 'quantity',
    sd.sls_price    as 'price'
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO
