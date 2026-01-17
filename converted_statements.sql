-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG (PostgreSQL)
-- Microsoft SQL Server to PostgreSQL Migration
-- ============================================================================
-- This file contains all SQL statements converted from SQL Server to PostgreSQL.
-- Each statement includes the original SQL Server version, the converted
-- PostgreSQL version, and conversion metadata.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Source: AuthorsController.cs, EditUsingStoredProcedure method, line 166
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: FAILED - Metadata model creation error
-- 
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
--
-- Conversion Notes:
-- - Converted EXEC stored procedure call to SELECT function call
-- - Removed DECLARE and variable assignment pattern
-- - PostgreSQL stored procedures/functions called via SELECT
-- - Schema remains bobsbookstore_dbo
-- - Parameters keep @ prefix (Npgsql compatible)
-- ----------------------------------------------------------------------------

SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ----------------------------------------------------------------------------
-- STATEMENT 2: Select All Authors (Simple Query)
-- ----------------------------------------------------------------------------
-- Source: AuthorsController.cs, FindAllAuthorsEmbeddedSql method, line 188
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: FAILED - Metadata model creation error
--
-- Original SQL Server Statement:
-- SELECT * FROM bobsbookstore_dbo.author
--
-- Conversion Notes:
-- - Statement is already PostgreSQL-compatible
-- - No SQL Server-specific syntax present
-- - Schema reference unchanged
-- ----------------------------------------------------------------------------

SELECT * FROM bobsbookstore_dbo.author

-- ----------------------------------------------------------------------------
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Source: AuthorsController.cs, DeleteAuthorEmbeddedSql method, line 207
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: FAILED - Metadata model creation error
--
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
--
-- Conversion Notes:
-- - Converted EXEC stored procedure call to SELECT function call
-- - Removed DECLARE and variable assignment pattern
-- - Function returns rows affected count
-- - Schema remains bobsbookstore_dbo
-- ----------------------------------------------------------------------------

SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- ----------------------------------------------------------------------------
-- STATEMENT 4: Select Authors by Hire Year (Complex Query with Functions)
-- ----------------------------------------------------------------------------
-- Source: AuthorsController.cs, SelectAuthorsByHireYear method, line 224
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: FAILED - Metadata model creation error
--
-- Original SQL Server Statement:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- Conversion Notes:
-- - FORMAT(date, format) → TO_CHAR(date, format)
--   * Format string adjusted: 'yyyy-MM-dd HH:mm:ss' → 'YYYY-MM-DD HH24:MI:SS'
-- - DATEDIFF(YEAR, start, end) → EXTRACT(YEAR FROM AGE(end, start))
-- - GETDATE() → CURRENT_TIMESTAMP
-- - DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
-- - All function conversions follow PostgreSQL standards
-- ----------------------------------------------------------------------------

SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ----------------------------------------------------------------------------
-- STATEMENT 5: Get All Product Data (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Source: ProductsController.cs, FindAllProducts method, line 31
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: FAILED - Metadata model creation error
--
-- Original SQL Server Statement:
-- EXEC [dbo].[uspGetProductData];
--
-- Conversion Notes:
-- - Converted EXEC to SELECT * FROM function call
-- - PostgreSQL function calls that return table data use SELECT * FROM
-- - Schema changed from [dbo] to bobsbookstore_dbo
-- - Added parentheses for function call syntax
-- ----------------------------------------------------------------------------

SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total SQL Statements: 5
-- DMS Tool Successful: 0
-- Manual Conversions: 5
--
-- All statements attempted through DMS MCP tool but failed with metadata errors.
-- All conversions performed manually following PostgreSQL best practices.
--
-- Key Conversion Patterns Applied:
-- 1. Stored Procedure Execution:
--    SQL Server: EXEC [dbo].[proc] @param
--    PostgreSQL: SELECT schema.proc(@param) OR SELECT * FROM schema.proc()
--
-- 2. Date/Time Functions:
--    FORMAT() → TO_CHAR()
--    GETDATE() → CURRENT_TIMESTAMP or NOW()
--    DATEDIFF() → EXTRACT(YEAR FROM AGE())
--    DATEPART() → EXTRACT()
--
-- 3. Schema References:
--    [dbo] → bobsbookstore_dbo (consistent with existing code)
--
-- 4. Parameter Syntax:
--    @param remains unchanged (Npgsql supports @ prefix)
--
-- All statements ready for equivalency validation in Step 3.
-- ============================================================================
