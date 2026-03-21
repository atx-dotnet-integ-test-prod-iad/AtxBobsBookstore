-- ============================================================================
-- Extracted SQL Statements Catalog
-- Source: Microsoft SQL Server to PostgreSQL Migration
-- Extraction Date: 2026-03-21
-- Total Statements: 5
-- ============================================================================

-- ============================================================================
-- Statement 1: EditUsingStoredProcedure
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Original Line: ~161
-- Type: Stored Procedure Execution
-- ============================================================================
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;

-- ============================================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Original Line: ~185
-- Type: SELECT query
-- ============================================================================
SELECT * FROM [dbo].[Author];

-- ============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Original Line: ~206
-- Type: Stored Procedure Execution
-- ============================================================================
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;

-- ============================================================================
-- Statement 4: SelectAuthorsByHireYear
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Original Line: ~226
-- Type: SELECT query with CONVERT, DATEDIFF, GETDATE functions
-- ============================================================================
SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;

-- ============================================================================
-- Statement 5: FindAllProducts
-- File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Original Line: ~34
-- Type: Stored Procedure Execution
-- ============================================================================
EXEC [dbo].[uspGetProductData];
