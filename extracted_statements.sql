-- ===============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2026-02-11
-- ===============================================================================
-- This file contains all SQL statements extracted from the BobsBookstore
-- application that require conversion from SQL Server T-SQL to PostgreSQL syntax.
-- Each statement is documented with metadata including source location, statement
-- type, and complexity assessment.
-- ===============================================================================

-- ===============================================================================
-- STATEMENT ID: STMT-001
-- SOURCE FILE: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- METHOD: EditUsingStoredProcedure
-- LINE NUMBER: ~155
-- STATEMENT TYPE: EXEC (Stored Procedure Call with DECLARE and SELECT)
-- COMPLEXITY: HIGH (T-SQL specific DECLARE, EXEC with return value, multiple parameters)
-- DESCRIPTION: Calls stored procedure uspUpdateAuthorPersonalInfo to update author
--              personal information. Uses T-SQL DECLARE for output variable pattern.
-- PARAMETERS: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime),
--             @MaritalStatus (string), @Gender (string)
-- ===============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ===============================================================================
-- STATEMENT ID: STMT-002
-- SOURCE FILE: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- METHOD: FindAllAuthorsEmbeddedSql
-- LINE NUMBER: ~174
-- STATEMENT TYPE: SELECT
-- COMPLEXITY: LOW (Simple SELECT with schema qualification)
-- DESCRIPTION: Retrieves all authors from the author table
-- PARAMETERS: None
-- ===============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ===============================================================================
-- STATEMENT ID: STMT-003
-- SOURCE FILE: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- METHOD: DeleteAuthorEmbeddedSql
-- LINE NUMBER: ~192
-- STATEMENT TYPE: EXEC (Stored Procedure Call with DECLARE and SELECT)
-- COMPLEXITY: HIGH (T-SQL specific DECLARE, EXEC with return value, single parameter)
-- DESCRIPTION: Calls stored procedure uspDeleteAuthor to delete an author.
--              Uses T-SQL DECLARE for output variable pattern.
-- PARAMETERS: @BusinessEntityID (int)
-- ===============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ===============================================================================
-- STATEMENT ID: STMT-004
-- SOURCE FILE: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- METHOD: SelectAuthorsByHireYear
-- LINE NUMBER: ~209
-- STATEMENT TYPE: SELECT
-- COMPLEXITY: HIGH (Multiple T-SQL functions: FORMAT, DATEDIFF, GETDATE, DATEPART)
-- DESCRIPTION: Retrieves authors hired in a specific year with calculated age and
--              formatted modified date. Uses multiple SQL Server specific functions.
-- PARAMETERS: @HireDate (int - year value)
-- T-SQL FUNCTIONS USED:
--   - FORMAT(date, format_string): Formats date as string
--   - DATEDIFF(YEAR, start_date, end_date): Calculates difference in years
--   - GETDATE(): Returns current date/time
--   - DATEPART(YEAR, date): Extracts year from date
-- ===============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ===============================================================================
-- STATEMENT ID: STMT-005
-- SOURCE FILE: /sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- METHOD: FindAllProducts
-- LINE NUMBER: ~32
-- STATEMENT TYPE: EXEC (Stored Procedure Call)
-- COMPLEXITY: MEDIUM (Simple stored procedure execution)
-- DESCRIPTION: Calls stored procedure uspGetProductData to retrieve all products
-- PARAMETERS: None
-- ===============================================================================
EXEC [dbo].[uspGetProductData];

-- ===============================================================================
-- EXTRACTION SUMMARY
-- ===============================================================================
-- Total Statements Extracted: 5
-- Statement Types:
--   - EXEC (Stored Procedure): 3
--   - SELECT: 2
-- Complexity Distribution:
--   - HIGH: 3 statements
--   - MEDIUM: 1 statement
--   - LOW: 1 statement
-- T-SQL Functions Requiring Conversion:
--   - DECLARE/EXEC pattern (3 occurrences)
--   - FORMAT() (1 occurrence)
--   - DATEDIFF() (1 occurrence)
--   - GETDATE() (1 occurrence)
--   - DATEPART() (1 occurrence)
-- Schema References:
--   - [dbo].* (3 occurrences - stored procedures)
--   - bobsbookstore_dbo.* (2 occurrences - table references)
-- ===============================================================================
