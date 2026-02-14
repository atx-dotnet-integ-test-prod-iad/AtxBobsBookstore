-- ============================================================================
-- Extracted SQL Statements from BobsBookstore Application
-- Extraction Date: 2026-02-14
-- Purpose: Catalog all SQL statements for DMS conversion from SQL Server to PostgreSQL
-- ============================================================================

-- ============================================================================
-- STATEMENT 1
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~160
-- Type: Stored Procedure Call with Output Parameter
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Description: Updates author personal information using stored procedure uspUpdateAuthorPersonalInfo
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~180
-- Type: Direct SELECT query
-- Parameters: None
-- Description: Retrieves all authors from the bobsbookstore_dbo.author table
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- STATEMENT 3
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~200
-- Type: Stored Procedure Call with Output Parameter
-- Parameters: @BusinessEntityID (int)
-- Description: Deletes an author using stored procedure uspDeleteAuthor
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~216
-- Type: SELECT query with SQL Server specific functions
-- Parameters: @HireDate (int - year value)
-- Description: Selects authors hired in a specific year with age calculation
-- SQL Server Functions Used: FORMAT, DATEDIFF, GETDATE, DATEPART
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~32
-- Type: Stored Procedure Call
-- Parameters: None
-- Description: Retrieves all products using stored procedure uspGetProductData
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- END OF EXTRACTED STATEMENTS
-- Total Count: 5 statements
-- ============================================================================
