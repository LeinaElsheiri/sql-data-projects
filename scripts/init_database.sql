/*
============================================================
Create Database and Schemas
============================================================

Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
    within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/




-- create database 'DataWarehouse'
use master;

-- Drop and recreate the 'DataWarehouse' database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- create the database called DataWarehouse
CREATE DATABASE DataWarehouse;

GO

-- Switch to new database which is DataWarehouse
use DataWarehouse;

-- creating schemas for each layer
create schema bronze;
GO -- GO: It's like  seperator, like said first excute seperately first command before going second one.
create schema silver;
-- SEPARATE BACTCHES WHEN WORKING WITH MULTIPLE SQL STATEMNETS
GO
create schema gold;
GO
