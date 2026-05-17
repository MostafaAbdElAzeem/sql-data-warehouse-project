/*
-----------------------------------
Creating Database and Schemas
-----------------------------------
Purpose of Script:
- Creating Database "DataWareHouse" after checking if it already exists or not
- Switching to use "DataWareHouse" database
- Creating Schemas for Bronze, silver and gold layers

Note: 
	- Running this script will drop the entire 'DataWarehouse' database if it exists. 
   
*/

--Check if DB exists if so, drop it and recreate a new one
use master;
GO
IF  EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWareHouse')
	BEGIN
		alter database  DataWarehouse set single_user with rollback immediate;
		drop database DataWarehouse;
	END;
GO
create database DataWarehouse;
GO

--Switching to DataWarehouse DB
use DataWarehouse;
GO

--Creating Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
