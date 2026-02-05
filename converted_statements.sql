-- ============================================================================
-- SQL Statement Conversion Catalog
-- Migration: Microsoft SQL Server to PostgreSQL
-- Conversion Date: 2026-02-04
-- ============================================================================
-- NOTE: All statements were processed through DMS MCP tool but encountered 
-- errors during metadata model creation. Manual conversions were performed
-- following PostgreSQL best practices while documenting DMS tool attempts.
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: uspUpdateAuthorPersonalInfo Stored Procedure Call
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 162
-- Method: EditUsingStoredProcedure
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE

-- ORIGINAL SQL SERVER STATEMENT:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Timestamp: 2026-02-04T23:40:15.565935

-- CONVERTED POSTGRESQL STATEMENT:
-- PostgreSQL stored procedures are called using SELECT FROM function or CALL statement
-- Since this returns a value (rows affected), we use SELECT FROM function approach
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- CONVERSION NOTES:
-- 1. Removed DECLARE statement (not needed in PostgreSQL inline SQL)
-- 2. Changed EXEC to SELECT * FROM function_name()
-- 3. Maintained parameter names with @ prefix (Npgsql supports this)
-- 4. Schema [dbo] mapped to bobsbookstore_dbo
-- 5. Procedure name converted to lowercase (PostgreSQL convention)
-- 6. The stored procedure on PostgreSQL side should return a table or scalar value

-- ============================================================================
-- STATEMENT 2: SELECT with SQL Server Date Functions
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 230
-- Method: SelectAuthorsByHireYear
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE

-- ORIGINAL SQL SERVER STATEMENT:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Timestamp: 2026-02-04T23:40:28.304028

-- CONVERTED POSTGRESQL STATEMENT:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- CONVERSION NOTES:
-- 1. FORMAT(date, pattern) → TO_CHAR(date, pattern)
--    - SQL Server pattern 'yyyy-MM-dd HH:mm:ss' → PostgreSQL pattern 'YYYY-MM-DD HH24:MI:SS'
--    - HH24 for 24-hour format, MI for minutes, SS for seconds
-- 2. DATEDIFF(YEAR, BirthDate, GETDATE()) → DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate))
--    - AGE() returns an interval between two timestamps
--    - DATE_PART extracts the year component
-- 3. GETDATE() → CURRENT_TIMESTAMP (standard SQL, also NOW() works)
-- 4. DATEPART(YEAR, HireDate) → EXTRACT(YEAR FROM HireDate)
-- 5. Schema bobsbookstore_dbo retained as-is
-- 6. Parameter @HireDate maintained with @ prefix

-- ============================================================================
-- STATEMENT 3: uspDeleteAuthor Stored Procedure Call
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 213
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE

-- ORIGINAL SQL SERVER STATEMENT:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Timestamp: 2026-02-04T23:40:41.214966

-- CONVERTED POSTGRESQL STATEMENT:
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- CONVERSION NOTES:
-- 1. Removed DECLARE statement
-- 2. Changed EXEC to SELECT * FROM function_name()
-- 3. Maintained parameter name with @ prefix
-- 4. Schema [dbo] mapped to bobsbookstore_dbo
-- 5. Procedure name converted to lowercase
-- 6. Single parameter @BusinessEntityID

-- ============================================================================
-- STATEMENT 4: Simple SELECT from author table
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 189
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE

-- ORIGINAL SQL SERVER STATEMENT:
-- SELECT * FROM bobsbookstore_dbo.author

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Timestamp: 2026-02-04T23:40:52.204828

-- CONVERTED POSTGRESQL STATEMENT:
SELECT * FROM bobsbookstore_dbo.author;

-- CONVERSION NOTES:
-- 1. Statement is PostgreSQL-compatible as-is
-- 2. Added semicolon for consistency
-- 3. Schema and table name remain unchanged
-- 4. No SQL Server specific syntax in this statement

-- ============================================================================
-- STATEMENT 5: uspGetProductData Stored Procedure Call
-- ============================================================================
-- Source File: ProductsController.cs
-- Line Number: 31
-- Method: FindAllProducts
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE

-- ORIGINAL SQL SERVER STATEMENT:
-- EXEC [dbo].[uspGetProductData];

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Timestamp: 2026-02-04T23:41:07.374790

-- CONVERTED POSTGRESQL STATEMENT:
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- CONVERSION NOTES:
-- 1. Changed EXEC to SELECT * FROM function_name()
-- 2. Schema [dbo] mapped to bobsbookstore_dbo
-- 3. Procedure name converted to lowercase
-- 4. No parameters required
-- 5. Added parentheses for function call syntax

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total Statements Processed: 5
-- DMS Tool Successful Conversions: 0
-- Manual Conversions After DMS Failure: 5
--
-- Common Conversion Patterns Applied:
-- 1. EXEC stored_proc → SELECT * FROM stored_proc()
-- 2. DECLARE variables removed (handled by PostgreSQL internally)
-- 3. FORMAT() → TO_CHAR() with pattern adjustment
-- 4. DATEDIFF() → DATE_PART() with AGE()
-- 5. GETDATE() → CURRENT_TIMESTAMP
-- 6. DATEPART() → EXTRACT()
-- 7. [dbo] schema → bobsbookstore_dbo
-- 8. Procedure/function names converted to lowercase
-- 9. Parameter names maintained with @ prefix (Npgsql compatible)
--
-- Critical Notes:
-- - All stored procedures must exist in PostgreSQL database as functions
-- - Stored procedure signatures must match parameter expectations
-- - Return types must be compatible with EF Core mapping
-- - Schema bobsbookstore_dbo must exist in PostgreSQL database
-- ============================================================================
