-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- ============================================================================
-- This file contains all SQL statements extracted from the BobsBookstore
-- .NET application codebase for migration from SQL Server to PostgreSQL.
-- Each statement is documented with source location and context.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Source File: /app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: 166
-- Type: EXEC (Stored Procedure with DECLARE and SELECT)
-- Context: Updates author personal information using stored procedure uspUpdateAuthorPersonalInfo
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), 
--             @MaritalStatus (string), @Gender (string)
-- Description: Declares a variable to capture rows affected, executes the stored procedure
--              to update author data, and returns the rows affected count
-- ----------------------------------------------------------------------------

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ----------------------------------------------------------------------------
-- STATEMENT 2: Select All Authors (Simple Query)
-- ----------------------------------------------------------------------------
-- Source File: /app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: 188
-- Type: SELECT
-- Context: Retrieves all author records from the author table
-- Parameters: None
-- Description: Simple SELECT statement to retrieve all columns from the author table
--              in the bobsbookstore_dbo schema
-- ----------------------------------------------------------------------------

SELECT * FROM bobsbookstore_dbo.author

-- ----------------------------------------------------------------------------
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Source File: /app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: 207
-- Type: EXEC (Stored Procedure with DECLARE and SELECT)
-- Context: Deletes an author using stored procedure uspDeleteAuthor
-- Parameters: @BusinessEntityID (int)
-- Description: Declares a variable to capture rows affected, executes the stored procedure
--              to delete author, and returns the rows affected count
-- ----------------------------------------------------------------------------

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ----------------------------------------------------------------------------
-- STATEMENT 4: Select Authors by Hire Year with Functions (Complex Query)
-- ----------------------------------------------------------------------------
-- Source File: /app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: 224
-- Type: SELECT with SQL Server-specific functions
-- Context: Retrieves authors hired in a specific year with formatted dates and calculated age
-- Parameters: @HireDate (int - year value)
-- Description: Complex SELECT using SQL Server-specific functions:
--              - FORMAT() to format ModifiedDate as 'yyyy-MM-dd HH:mm:ss'
--              - DATEDIFF() with YEAR to calculate age from BirthDate to current date
--              - GETDATE() to get current date/time
--              - DATEPART() with YEAR to extract year from HireDate for filtering
-- ----------------------------------------------------------------------------

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ----------------------------------------------------------------------------
-- STATEMENT 5: Get All Product Data (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Source File: /app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: 31
-- Type: EXEC (Stored Procedure)
-- Context: Retrieves all product data using stored procedure uspGetProductData
-- Parameters: None
-- Description: Simple stored procedure execution to retrieve product data
-- ----------------------------------------------------------------------------

EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total SQL Statements: 5
-- Stored Procedure Calls: 3 (statements 1, 3, 5)
-- Simple SELECT Queries: 1 (statement 2)
-- Complex SELECT Queries: 1 (statement 4)
-- 
-- Files Processed:
-- 1. AuthorsController.cs - 4 SQL statements
-- 2. ProductsController.cs - 1 SQL statement
--
-- SQL Server-Specific Features Identified:
-- - DECLARE and EXEC syntax for stored procedures
-- - [dbo] schema qualifier
-- - FORMAT() function
-- - DATEDIFF() function
-- - GETDATE() function
-- - DATEPART() function
-- - Variable assignment in EXEC (@rowsAffected = ...)
-- - @-prefixed parameters
--
-- All statements are ready for DMS tool conversion in Step 2.
-- ============================================================================
