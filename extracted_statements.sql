-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- ============================================================================
-- This file contains all SQL statements extracted from the Bob's Bookstore
-- application codebase that need to be converted to PostgreSQL syntax.
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Edit Author Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: 155
-- Type: Stored Procedure Call with DECLARE statement
-- Parameters: 
--   @BusinessEntityID (int) - businessEntityId
--   @NationalIDNumber (string) - nationalIdNumber
--   @BirthDate (DateTime) - birthDate.ToUniversalTime()
--   @MaritalStatus (string) - maritalStatus
--   @Gender (string) - gender
-- Construction: Inline SQL string
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: Find All Authors
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: 179
-- Type: SELECT statement
-- Parameters: None
-- Schema: bobsbookstore_dbo
-- Table: author
-- Construction: Inline SQL string
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: 199
-- Type: Stored Procedure Call with DECLARE statement
-- Parameters:
--   @BusinessEntityID (int) - businessEntityId
-- Construction: Inline SQL string
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: Select Authors By Hire Year
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: 218
-- Type: Complex SELECT with date functions
-- Parameters:
--   @HireDate (int) - hireYear
-- Schema: bobsbookstore_dbo
-- Table: author
-- SQL Server Functions Used:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') - Format date as string
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) - Calculate age in years
--   - GETDATE() - Get current date/time
--   - DATEPART(YEAR, HireDate) - Extract year from hire date
-- Construction: Inline SQL string
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: Get Product Data Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: 30
-- Type: Stored Procedure Call
-- Parameters: None
-- Construction: Inline SQL string
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Total SQL Statements: 5
-- Statements with Stored Procedures: 3 (statements 1, 3, 5)
-- Statements with Complex Date Functions: 1 (statement 4)
-- Statements with Simple SELECT: 1 (statement 2)
-- Schema Used: bobsbookstore_dbo (for table references)
-- Schema Used: dbo (for stored procedures)
-- 
-- SQL Server Specific Constructs Identified:
-- 1. DECLARE @variable syntax (statements 1, 3)
-- 2. EXEC stored procedure calls (statements 1, 3, 5)
-- 3. [schema].[object] bracket notation (all statements)
-- 4. FORMAT() function (statement 4)
-- 5. DATEDIFF() function (statement 4)
-- 6. GETDATE() function (statement 4)
-- 7. DATEPART() function (statement 4)
-- 8. Return value assignment from stored procedures (@rowsAffected = EXEC)
-- ============================================================================

-- ============================================================================
-- PARAMETER DETAILS
-- ============================================================================
-- All parameters use @ParameterName syntax (SQL Server style)
-- Parameter types identified:
--   - INT: @BusinessEntityID, @HireDate
--   - VARCHAR/STRING: @NationalIDNumber, @MaritalStatus, @Gender
--   - DATETIME: @BirthDate (passed as UTC from .NET code)
-- 
-- Npgsql supports @ParameterName syntax, so parameter names don't need to change
-- Only the SQL syntax within the statements needs PostgreSQL conversion
-- ============================================================================
