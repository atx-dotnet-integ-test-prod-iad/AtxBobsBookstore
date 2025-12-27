-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- SQL Server to PostgreSQL Migration
-- Source: BobsBookstore Application
-- Date: 2024-12-27
-- ============================================================================
-- This catalog contains all SQL statements extracted from the codebase.
-- Each statement is documented with:
--   - Statement ID
--   - Source File Path
--   - Line Number
--   - Method Name
--   - Statement Type
--   - Original SQL Statement
-- ============================================================================

-- ============================================================================
-- STATEMENT 1
-- ============================================================================
-- SOURCE FILE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: 164
-- METHOD: EditUsingStoredProcedure
-- STATEMENT TYPE: EXEC (Stored Procedure Call with DECLARE and variable)
-- DESCRIPTION: Updates author personal information using stored procedure
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2
-- ============================================================================
-- SOURCE FILE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: 188
-- METHOD: FindAllAuthorsEmbeddedSql
-- STATEMENT TYPE: SELECT
-- DESCRIPTION: Retrieves all authors from the author table
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3
-- ============================================================================
-- SOURCE FILE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: 209
-- METHOD: DeleteAuthorEmbeddedSql
-- STATEMENT TYPE: EXEC (Stored Procedure Call with DECLARE and variable)
-- DESCRIPTION: Deletes an author using stored procedure
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4
-- ============================================================================
-- SOURCE FILE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: 229
-- METHOD: SelectAuthorsByHireYear
-- STATEMENT TYPE: SELECT with SQL Server-specific functions
-- DESCRIPTION: Retrieves authors hired in a specific year with formatted date and age calculation
-- SQL SERVER FUNCTIONS USED: FORMAT, DATEDIFF, GETDATE, DATEPART
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5
-- ============================================================================
-- SOURCE FILE: app/Bookstore.Web/Controllers/ProductsController.cs
-- LINE NUMBER: 32
-- METHOD: FindAllProducts
-- STATEMENT TYPE: EXEC (Stored Procedure Call)
-- DESCRIPTION: Retrieves all product data using stored procedure
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Total Statements Extracted: 5
-- 
-- Breakdown by Type:
--   - EXEC (Stored Procedure): 3 statements
--   - SELECT: 2 statements
--
-- Files with SQL Statements:
--   - app/Bookstore.Web/Controllers/AuthorsController.cs: 4 statements
--   - app/Bookstore.Web/Controllers/ProductsController.cs: 1 statement
--
-- SQL Server-Specific Features Detected:
--   - DECLARE statements with variables
--   - Stored procedure calls with [schema].[procedure] notation
--   - FORMAT function (SQL Server date formatting)
--   - DATEDIFF function (SQL Server date calculation)
--   - GETDATE function (SQL Server current date/time)
--   - DATEPART function (SQL Server date part extraction)
--   - Schema-qualified object names: [dbo].[procedureName]
--   - Schema name: bobsbookstore_dbo
-- ============================================================================
