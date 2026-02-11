-- ===============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2026-02-11
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (All 5 statements)
-- ===============================================================================
-- This file contains all SQL statements converted from SQL Server T-SQL to 
-- PostgreSQL syntax. All statements were attempted through DMS MCP tool first,
-- but all failed with metadata model creation error. Manual conversions were
-- provided based on standard SQL Server to PostgreSQL conversion patterns.
-- ===============================================================================

-- ===============================================================================
-- STATEMENT ID: STMT-001
-- SOURCE FILE: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- METHOD: EditUsingStoredProcedure
-- CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
-- DMS ERROR: Metadata model creation failed: Unknown metadata model creation status: RECEIVED
-- ===============================================================================
-- ORIGINAL (SQL Server):
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- CONVERSION NOTES:
-- PostgreSQL stored procedures are called as functions using SELECT.
-- The DECLARE/EXEC pattern is not needed in PostgreSQL.
-- Function names are typically converted to lowercase.
-- Schema prefix maintained.

-- ===============================================================================
-- STATEMENT ID: STMT-002
-- SOURCE FILE: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- METHOD: FindAllAuthorsEmbeddedSql
-- CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE (No changes needed - already compatible)
-- DMS ERROR: Metadata model creation failed: Unknown metadata model creation status: RECEIVED
-- ===============================================================================
-- ORIGINAL (SQL Server):
-- SELECT * FROM bobsbookstore_dbo.author;

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author;

-- CONVERSION NOTES:
-- This statement is already PostgreSQL compatible. No changes needed.
-- Schema-qualified table name is valid in PostgreSQL.

-- ===============================================================================
-- STATEMENT ID: STMT-003
-- SOURCE FILE: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- METHOD: DeleteAuthorEmbeddedSql
-- CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
-- DMS ERROR: Metadata model creation failed: Unknown metadata model creation status: RECEIVED
-- ===============================================================================
-- ORIGINAL (SQL Server):
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- CONVERSION NOTES:
-- PostgreSQL stored procedures are called as functions using SELECT.
-- The DECLARE/EXEC pattern is not needed in PostgreSQL.
-- Function names are typically converted to lowercase.
-- Schema prefix maintained.

-- ===============================================================================
-- STATEMENT ID: STMT-004
-- SOURCE FILE: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- METHOD: SelectAuthorsByHireYear
-- CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
-- DMS ERROR: Metadata model creation failed: Unknown metadata model creation status: RECEIVED
-- ===============================================================================
-- ORIGINAL (SQL Server):
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
--        DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
-- FROM bobsbookstore_dbo.author 
-- WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- CONVERTED (PostgreSQL):
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- CONVERSION NOTES:
-- Multiple T-SQL function conversions:
-- - FORMAT() -> TO_CHAR() with PostgreSQL format string
-- - DATEDIFF(YEAR, ..., GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, ...))
-- - GETDATE() -> CURRENT_TIMESTAMP
-- - DATEPART(YEAR, ...) -> EXTRACT(YEAR FROM ...)
-- Format string changes: 'yyyy' -> 'YYYY', 'HH' -> 'HH24', 'mm' -> 'MI', 'ss' -> 'SS'

-- ===============================================================================
-- STATEMENT ID: STMT-005
-- SOURCE FILE: /sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- METHOD: FindAllProducts
-- CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
-- DMS ERROR: Metadata model creation failed: Unknown metadata model creation status: RECEIVED
-- ===============================================================================
-- ORIGINAL (SQL Server):
-- EXEC [dbo].[uspGetProductData];

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- CONVERSION NOTES:
-- PostgreSQL stored procedures that return result sets are called as 
-- table-valued functions using SELECT * FROM.
-- Function names are typically converted to lowercase.
-- Schema prefix maintained.

-- ===============================================================================
-- CONVERSION SUMMARY
-- ===============================================================================
-- Total Statements Converted: 5
-- DMS Tool Successful Conversions: 0
-- Manual Conversions After DMS Failure: 5
-- Conversion Patterns Applied:
--   - DECLARE/EXEC with return value -> SELECT function() (2 occurrences)
--   - EXEC procedure -> SELECT * FROM function() (1 occurrence)
--   - FORMAT() -> TO_CHAR() (1 occurrence)
--   - DATEDIFF() -> EXTRACT(YEAR FROM AGE()) (1 occurrence)
--   - GETDATE() -> CURRENT_TIMESTAMP (1 occurrence)
--   - DATEPART() -> EXTRACT() (1 occurrence)
--   - Schema preservation: [dbo].* -> bobsbookstore_dbo.* (lowercase function names)
--   - Already compatible: Simple SELECT (1 occurrence)
-- ===============================================================================
