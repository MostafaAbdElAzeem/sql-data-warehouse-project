/*
------------------------------------------
Quality Checks: Gold layer
------------------------------------------
Purpose: 
		- Applying checks on gold layer views to validate the integrity, consistency, 
		  and accuracy of the Gold Layer.

------------------------------------------
*/

-- ** 1- dim_customers **
select * from gold.dim_customers

-- Check for Uniqueness of Customer Key in gold.dim_customers
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers d
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- ** 2- dim_products **
select * from gold.dim_products

-- Check for Uniqueness of Customer Key in gold.dim_products
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products 
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ** 3- fact_sales **

select * 
from gold.fact_sales

-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  
