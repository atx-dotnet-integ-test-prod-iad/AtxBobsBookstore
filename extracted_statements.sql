-- ============================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Purpose: Comprehensive inventory of all SQL statements for DMS conversion
-- Generated: 2026-03-22
-- Updated: 2026-03-22 (Step 1 re-execution)
-- Total Statements: 5
-- ============================================================

-- ============================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~165
-- Description: Stored procedure call for updating author personal info
-- Context: Called within try/catch block, result used to determine success
-- Original MS SQL Statement:
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~189
-- Description: Simple SELECT query to retrieve all authors
-- Context: Results mapped to List<Author> via SqlQueryRaw
-- Original MS SQL Statement:
-- ============================================================
SELECT * FROM [dbo].[Author]

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~212
-- Description: Stored procedure call for deleting an author
-- Context: Called within try/catch block, result used to determine success
-- Original MS SQL Statement:
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~232
-- Description: Complex SELECT with date functions - uses CONVERT, DATEDIFF, GETDATE
-- Context: Results mapped to List<AuthorAgeResult> via SqlQueryRaw with @HireDate parameter
-- Original MS SQL Statement:
-- ============================================================
SELECT BusinessEntityID, CONVERT(VARCHAR(10), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEDIFF(YEAR, HireDate, GETDATE()) >= @HireDate

-- ============================================================
-- Statement 5: FindAllProducts
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~37
-- Description: Stored procedure call for retrieving product data
-- Context: Results mapped to List<Product> via SqlQueryRaw
-- Original MS SQL Statement:
-- ============================================================
EXEC [dbo].[uspGetProductData];
