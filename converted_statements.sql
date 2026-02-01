-- =====================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- BobsBookstore .NET Application - SQL Server to PostgreSQL Migration
-- =====================================================================
-- This file catalogs all converted SQL statements from SQL Server syntax
-- to PostgreSQL syntax.
-- =====================================================================
-- CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
-- All 4 statements failed DMS conversion due to metadata model errors
-- Error: "Metadata model creation failed: The selected objects were not found"
-- Manual conversion applied based on SQL Server to PostgreSQL syntax rules
-- =====================================================================

-- =====================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- =====================================================================
-- Original SQL (SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- DMS Tool Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Timestamp: 2026-02-01T07:29:23.531925

-- Converted SQL (PostgreSQL):
-- DO $$
-- DECLARE
--     rows_affected INT;
-- BEGIN
--     SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5) INTO rows_affected;
-- END $$;
-- SELECT rows_affected;

-- Note: PostgreSQL stored procedures are called as functions using SELECT statement
-- Parameters use numbered placeholders ($1, $2, etc.) instead of named parameters
-- Variable names use lowercase with underscores (PostgreSQL convention)
-- Schema qualification: bobsbookstore_dbo.uspupdateauthorpersonalinfo
-- For ExecuteSqlRawAsync, we can simplify to just call the function:
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Simplified version for code integration (returns the result directly):
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender) AS rows_affected;
-- =====================================================================

-- =====================================================================
-- STATEMENT 2: Select All Authors
-- =====================================================================
-- Original SQL (SQL Server):
-- SELECT * FROM bobsbookstore_dbo.author

-- DMS Tool Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Timestamp: 2026-02-01T07:29:46.427097

-- Converted SQL (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author;

-- Note: This query is already PostgreSQL compatible
-- Schema and table name remain the same
-- No SQL Server specific functions used
-- =====================================================================

-- =====================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- =====================================================================
-- Original SQL (SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- DMS Tool Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Timestamp: 2026-02-01T07:30:13.896107

-- Converted SQL (PostgreSQL):
-- DO $$
-- DECLARE
--     rows_affected INT;
-- BEGIN
--     SELECT bobsbookstore_dbo.uspdeleteauthor($1) INTO rows_affected;
-- END $$;
-- SELECT rows_affected;

-- Simplified version for code integration:
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID) AS rows_affected;

-- Note: Same conversion pattern as Statement 1
-- PostgreSQL calls stored procedures as functions
-- =====================================================================

-- =====================================================================
-- STATEMENT 4: Select Authors By Hire Year with Date Functions
-- =====================================================================
-- Original SQL (SQL Server):
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- DMS Tool Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Timestamp: 2026-02-01T07:30:36.665428

-- Converted SQL (PostgreSQL):
SELECT 
    BusinessEntityID, 
    TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Conversion Notes:
-- 1. FORMAT(date, format) → TO_CHAR(date, format)
--    - 'yyyy-MM-dd HH:mm:ss' → 'YYYY-MM-DD HH24:MI:SS'
--    - PostgreSQL format patterns use uppercase and HH24 for 24-hour format
-- 2. DATEDIFF(YEAR, start, end) → EXTRACT(YEAR FROM AGE(end, start))
--    - PostgreSQL AGE() function calculates interval between dates
--    - EXTRACT(YEAR FROM ...) gets the year component
-- 3. GETDATE() → CURRENT_DATE or NOW()
--    - CURRENT_DATE returns date only
--    - NOW() returns date and time
-- 4. DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
--    - Direct equivalent in PostgreSQL
-- =====================================================================

-- =====================================================================
-- CONVERSION SUMMARY
-- =====================================================================
-- Total Statements: 4
-- DMS Tool Successful Conversions: 0
-- DMS Tool Failed Conversions: 4
-- Manual Conversions After DMS Failure: 4
-- 
-- DMS Failure Reason: Metadata model creation failed - schema objects not found
-- All statements were manually converted following SQL Server to PostgreSQL syntax rules
-- =====================================================================

-- =====================================================================
-- SQL SERVER TO POSTGRESQL MAPPING REFERENCE
-- =====================================================================
-- Stored Procedures:
--   SQL Server: EXEC [schema].[procedure] @param1, @param2
--   PostgreSQL: SELECT schema.procedure($1, $2) or schema.procedure(@param1, @param2)
--
-- Date Functions:
--   FORMAT(date, format) → TO_CHAR(date, format)
--   DATEDIFF(part, start, end) → EXTRACT(part FROM AGE(end, start))
--   GETDATE() → NOW() or CURRENT_DATE
--   DATEPART(part, date) → EXTRACT(part FROM date)
--
-- Parameters:
--   SQL Server: @paramName
--   PostgreSQL: @paramName (supported by Npgsql) or $1, $2, etc.
--
-- Variables:
--   SQL Server: DECLARE @var TYPE; SET @var = value;
--   PostgreSQL: DECLARE var TYPE; var := value;
-- =====================================================================


-- =====================================================================
-- STATEMENT 5: Get Product Data (Stored Procedure Call)
-- =====================================================================
-- Location: /sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Number: ~33
-- Context: Retrieves all product data using stored procedure
-- 
-- Original SQL Server Statement:
EXEC [dbo].[uspGetProductData];

-- Converted PostgreSQL Statement:
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- 
-- DMS Tool Status: FAILED
-- Error: Metadata model creation failed - schema objects not found
-- 
-- Conversion Details:
-- - Changed EXEC to SELECT * FROM for function call
-- - Schema qualified with bobsbookstore_dbo
-- - Lowercase function name per PostgreSQL conventions
-- - Added parentheses for function call syntax
-- - Assumes function returns result set (used by SqlQueryRaw)
-- 
-- Parameters: None
-- 
-- Usage: Called from Index action to display all products
-- Returns: List<Product>
-- =====================================================================
