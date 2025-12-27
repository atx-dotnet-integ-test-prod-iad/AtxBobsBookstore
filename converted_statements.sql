-- ================================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Bob's Bookstore - SQL Server to PostgreSQL Migration
-- ================================================================================
-- This catalog contains ALL PostgreSQL-converted SQL statements
-- Each statement includes conversion method and mapping to original statement
-- ================================================================================

-- ================================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ================================================================================
-- Original Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 163
-- Method: EditUsingStoredProcedure
-- Original Statement Type: Stored Procedure Call with DECLARE and EXEC
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: Error (Metadata model creation failed)
--
-- ORIGINAL SQL SERVER:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
--
-- CONVERSION NOTES:
-- - DECLARE/EXEC pattern converted to CALL statement
-- - Return value handling removed (relies on function/procedure implementation)
-- - Schema [dbo] mapped to bobsbookstore_dbo
-- - Parameters remain @param notation (PostgreSQL compatible)
-- ================================================================================

CALL bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ================================================================================
-- STATEMENT 2: Find All Authors (SELECT Query)
-- ================================================================================
-- Original Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 188
-- Method: FindAllAuthorsEmbeddedSql
-- Original Statement Type: SELECT
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: Error (Metadata model creation failed)
--
-- ORIGINAL SQL SERVER:
-- SELECT * FROM bobsbookstore_dbo.author
--
-- CONVERSION NOTES:
-- - Statement is PostgreSQL-compatible as-is
-- - No syntax changes required
-- - Schema notation bobsbookstore_dbo.author is valid in both databases
-- ================================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ================================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ================================================================================
-- Original Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 207
-- Method: DeleteAuthorEmbeddedSql
-- Original Statement Type: Stored Procedure Call with DECLARE and EXEC
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: Error (Metadata model creation failed)
--
-- ORIGINAL SQL SERVER:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
--
-- CONVERSION NOTES:
-- - DECLARE/EXEC pattern converted to CALL statement
-- - Return value handling removed (relies on function/procedure implementation)
-- - Schema [dbo] mapped to bobsbookstore_dbo
-- - Parameter remains @param notation (PostgreSQL compatible)
-- ================================================================================

CALL bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- ================================================================================
-- STATEMENT 4: Select Authors by Hire Year (Complex SELECT with Functions)
-- ================================================================================
-- Original Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 225
-- Method: SelectAuthorsByHireYear
-- Original Statement Type: SELECT with SQL Server-specific functions
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: Error (Metadata model creation failed)
--
-- ORIGINAL SQL SERVER:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- CONVERSION NOTES:
-- - FORMAT(date, pattern) → TO_CHAR(date, pattern)
-- - Format pattern: 'yyyy-MM-dd HH:mm:ss' → 'YYYY-MM-DD HH24:MI:SS'
-- - DATEDIFF(YEAR, date1, date2) → DATE_PART('year', AGE(date2, date1))
-- - GETDATE() → CURRENT_TIMESTAMP
-- - DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
-- - Schema and table references preserved
-- ================================================================================

SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ================================================================================
-- STATEMENT 5: Get Product Data (Stored Procedure Call)
-- ================================================================================
-- Original Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 30
-- Method: FindAllProducts
-- Original Statement Type: Stored Procedure Call with EXEC
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: Error (Metadata model creation failed)
--
-- ORIGINAL SQL SERVER:
-- EXEC [dbo].[uspGetProductData];
--
-- CONVERSION NOTES:
-- - EXEC statement converted to CALL statement
-- - Schema [dbo] mapped to bobsbookstore_dbo
-- - Bracket notation removed
-- - No parameters required
-- ================================================================================

CALL bobsbookstore_dbo.uspGetProductData();

-- ================================================================================
-- CONVERSION SUMMARY AND SCHEMA TRANSFORMATIONS
-- ================================================================================
-- Total Statements Converted: 5
-- Conversion Method for All: MANUAL_AFTER_DMS_FAILURE
-- Reason: DMS MCP tool metadata model creation failures
--
-- SCHEMA OBJECT NAME TRANSFORMATIONS:
-- Source Schema: dbo
-- Target Schema: bobsbookstore_dbo
--
-- Object Name Mappings:
-- [dbo].[uspUpdateAuthorPersonalInfo] → bobsbookstore_dbo.uspUpdateAuthorPersonalInfo
-- [dbo].[uspDeleteAuthor] → bobsbookstore_dbo.uspDeleteAuthor
-- [dbo].[uspGetProductData] → bobsbookstore_dbo.uspGetProductData
-- bobsbookstore_dbo.author → bobsbookstore_dbo.author (preserved)
--
-- CRITICAL: During code re-integration, use these converted schema names
-- as they reflect the actual PostgreSQL database schema structure.
--
-- SQL SERVER to POSTGRESQL FUNCTION CONVERSION REFERENCE:
-- FORMAT(date, 'yyyy-MM-dd HH:mm:ss') → TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')
-- DATEDIFF(YEAR, start, end) → DATE_PART('year', AGE(end, start))
-- GETDATE() → CURRENT_TIMESTAMP or NOW()
-- DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
-- EXEC [schema].[proc] → CALL schema.proc()
-- ================================================================================
