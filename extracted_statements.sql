-- Extracted SQL Statements Catalog
-- Source: MS SQL Server Application (BobsBookstore)
-- Generated during SQL Server to PostgreSQL Migration
-- All 5 original MS SQL statements extracted from the .NET codebase

-- ============================================================
-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~165
-- Description: Stored procedure call to update author personal info
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~190
-- Description: Simple SELECT to retrieve all authors
-- ============================================================
SELECT * FROM Author

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~211
-- Description: Stored procedure call to delete an author
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~231
-- Description: Complex SELECT with SQL Server date functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- ============================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================
-- Statement 5: FindAllProducts (ProductsController.cs)
-- Location: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~36
-- Description: Stored procedure call to retrieve all product data
-- ============================================================
EXEC [dbo].[uspGetProductData];
