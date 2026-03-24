-- ============================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Migration: MS SQL Server → PostgreSQL
-- ============================================

-- ============================================
-- APPLICATION CODE SQL STATEMENTS
-- ============================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method
SELECT * FROM [dbo].[Author]

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate

-- Statement 5: ProductsController.cs - FindAllProducts method
EXEC [dbo].[uspGetProductData];

-- ============================================
-- DATABASE SCHEMA STATEMENTS (adven.sql) - 84 statements
-- 6 CREATE TYPE, 11 CREATE TABLE, 31 ALTER TABLE, 10 CREATE INDEX,
-- 1 CREATE TRIGGER, 14 CREATE PROCEDURE, 7 CREATE FUNCTION, 4 CREATE VIEW
-- ============================================
-- See db/adven.sql for full original SQL Server DDL

-- ============================================
-- DATABASE SCHEMA STATEMENTS (bobsusedbooks.sql) - ~100 statements
-- CREATE DATABASE, CREATE USER, 6 CREATE TYPE, ~20 CREATE TABLE,
-- CREATE VIEW, CREATE PROCEDURE, ALTER TABLE, CREATE INDEX, INSERT statements
-- ============================================
-- See db/bobsusedbooks.sql for full original SQL Server DDL

-- ============================================
-- DATA INSERT STATEMENTS (adven-data.sql) - 9 INSERT batches
-- INSERT INTO Author, Person, BillOfMaterials, Product, Members,
-- Shopping, Coupons, ProductSaleRegions, ProductSales
-- ============================================
-- See db/adven-data.sql for full original data INSERT statements
