-- ===================================================================
-- SQL STATEMENT CONVERSION CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- ===================================================================
-- This file documents all SQL statement conversions with mappings
-- from original MS SQL Server syntax to PostgreSQL syntax
-- ===================================================================

-- ===================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Stored Procedure Call
-- ===================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~169
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- ===================================================================

-- ORIGINAL MS SQL:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- CONVERTED POSTGRESQL:
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo($1, $2, $3, $4, $5);

-- Note: PostgreSQL uses functions instead of stored procedures with EXEC. Parameter markers changed from @name to $1, $2, etc.
-- Schema name retained as bobsbookstore_dbo per existing code convention.
-- Function call directly returns the result, eliminating need for DECLARE and SELECT.

-- ===================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Simple SELECT
-- ===================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~189
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- ===================================================================

-- ORIGINAL MS SQL:
-- SELECT * FROM bobsbookstore_dbo.author

-- CONVERTED POSTGRESQL:
SELECT * FROM bobsbookstore_dbo.author

-- Note: This statement is already PostgreSQL compatible. Schema and table names retained.
-- No syntax changes required for basic SELECT.

-- ===================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure Call
-- ===================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~207
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- ===================================================================

-- ORIGINAL MS SQL:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- CONVERTED POSTGRESQL:
SELECT bobsbookstore_dbo.uspDeleteAuthor($1);

-- Note: PostgreSQL uses functions instead of stored procedures with EXEC. Parameter marker changed from @BusinessEntityID to $1.
-- Schema name retained as bobsbookstore_dbo per existing code convention.
-- Function call directly returns the result, eliminating need for DECLARE and SELECT.

-- ===================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with T-SQL Functions
-- ===================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~226
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- ===================================================================

-- ORIGINAL MS SQL:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- CONVERTED POSTGRESQL:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = $1;

-- Note: T-SQL to PostgreSQL function conversions:
-- - FORMAT(date, format) -> TO_CHAR(date, format) with PostgreSQL format syntax
-- - DATEDIFF(YEAR, date1, date2) -> EXTRACT(YEAR FROM AGE(date2, date1))
-- - GETDATE() -> CURRENT_DATE
-- - DATEPART(YEAR, date) -> EXTRACT(YEAR FROM date)
-- - @HireDate parameter -> $1 positional parameter
-- Schema and table names retained.

-- ===================================================================
-- STATEMENT 5: FindAllProducts - Stored Procedure Execution
-- ===================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~32
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- ===================================================================

-- ORIGINAL MS SQL:
-- EXEC [dbo].[uspGetProductData];

-- CONVERTED POSTGRESQL:
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- Note: PostgreSQL uses functions instead of stored procedures with EXEC.
-- Schema name retained as bobsbookstore_dbo per existing code convention.
-- Function call must be used in SELECT FROM syntax for table-returning functions.

-- ===================================================================
-- END OF CONVERSION CATALOG
-- Total Statements Converted: 5
-- DMS Tool Successful Conversions: 0
-- Manual Conversions After DMS Failure: 5
-- ===================================================================
