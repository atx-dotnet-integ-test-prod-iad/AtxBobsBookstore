-- ================================================================================================
-- CONVERTED SQL STATEMENTS FOR POSTGRESQL
-- Bob's Bookstore Application
-- Conversion Date: 2026-01-18
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (All statements failed DMS conversion)
-- ================================================================================================

-- ================================================================================================
-- STATEMENT 1: Edit Author Using Stored Procedure (CONVERTED)
-- ================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- 
-- DMS Conversion Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- 
-- Manual Conversion Applied: YES
-- Conversion Notes:
-- - SQL Server DECLARE/EXEC pattern converted to PostgreSQL function call with SELECT
-- - [dbo].[procedure] syntax converted to schema.procedure (bobsbookstore_dbo.procedure)
-- - PostgreSQL functions return values directly, no need for DECLARE or output variables
-- - Parameters use @ syntax (supported by Npgsql)

SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ================================================================================================
-- STATEMENT 2: Find All Authors (CONVERTED)
-- ================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Original SQL Server Statement:
-- SELECT * FROM bobsbookstore_dbo.author;
-- 
-- DMS Conversion Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- 
-- Manual Conversion Applied: YES
-- Conversion Notes:
-- - Simple SELECT statement, already PostgreSQL compatible
-- - Schema name already uses PostgreSQL format (bobsbookstore_dbo.author)
-- - No changes needed to syntax

SELECT * FROM bobsbookstore_dbo.author;

-- ================================================================================================
-- STATEMENT 3: Delete Author Using Stored Procedure (CONVERTED)
-- ================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- 
-- DMS Conversion Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- 
-- Manual Conversion Applied: YES
-- Conversion Notes:
-- - SQL Server DECLARE/EXEC pattern converted to PostgreSQL function call with SELECT
-- - [dbo].[procedure] syntax converted to schema.procedure (bobsbookstore_dbo.procedure)
-- - PostgreSQL functions return values directly, no need for DECLARE or output variables
-- - Parameter uses @ syntax (supported by Npgsql)

SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- ================================================================================================
-- STATEMENT 4: Select Authors By Hire Year with Age Calculation (CONVERTED)
-- ================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Original SQL Server Statement:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- 
-- DMS Conversion Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- 
-- Manual Conversion Applied: YES
-- Conversion Notes:
-- - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') → TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS')
--   * PostgreSQL uses different format codes: YYYY for year, MM for month, DD for day
--   * HH24 for 24-hour format, MI for minutes, SS for seconds
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) → EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate))
--   * PostgreSQL AGE function calculates interval between dates
--   * EXTRACT gets the year component from the interval
--   * CURRENT_TIMESTAMP replaces GETDATE()
-- - DATEPART(YEAR, HireDate) → EXTRACT(YEAR FROM HireDate)
--   * PostgreSQL EXTRACT function replaces DATEPART
-- - Schema name already uses PostgreSQL format

SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ================================================================================================
-- STATEMENT 5: Find All Products Using Stored Procedure (CONVERTED)
-- ================================================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Original SQL Server Statement:
-- EXEC [dbo].[uspGetProductData];
-- 
-- DMS Conversion Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- 
-- Manual Conversion Applied: YES
-- Conversion Notes:
-- - SQL Server EXEC statement converted to PostgreSQL SELECT FROM function
-- - [dbo].[procedure] syntax converted to schema.procedure (bobsbookstore_dbo.procedure)
-- - PostgreSQL stored procedures that return result sets must be called with SELECT * FROM
-- - No parameters needed

SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- ================================================================================================
-- CONVERSION SUMMARY
-- ================================================================================================
-- Total Statements: 5
-- DMS Successful Conversions: 0
-- DMS Failed Conversions: 5
-- Manual Conversions After DMS Failure: 5
-- 
-- DMS Failure Reason (All Statements):
-- Metadata model creation failed: The selected objects were not found.
-- This error indicates the DMS migration project could not locate the database objects
-- referenced in the SQL statements, likely due to migration project configuration or
-- database connection issues.
-- 
-- Manual Conversion Approach:
-- 1. Stored Procedures: Converted DECLARE/EXEC patterns to SELECT function_name(params)
-- 2. Date/Time Functions: Converted T-SQL functions to PostgreSQL equivalents
--    - FORMAT → TO_CHAR with PostgreSQL format codes
--    - DATEDIFF → AGE + EXTRACT
--    - DATEPART → EXTRACT
--    - GETDATE → CURRENT_TIMESTAMP
-- 3. Schema Qualifiers: Maintained bobsbookstore_dbo schema (already PostgreSQL format)
-- 4. Parameters: Kept @ syntax (supported by Npgsql)
-- 
-- All conversions follow PostgreSQL best practices and syntax requirements.
-- ================================================================================================
