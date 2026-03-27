-- ============================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET ADO Application
-- Date: 2026-03-27
-- Total Statements: 5
-- Note: These are the ORIGINAL MS SQL Server statements
-- ============================================================

-- ============================================================
-- Statement 1: FindAllAuthorsEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Type: Direct SELECT query
-- ============================================================
SELECT * FROM Author

-- ============================================================
-- Statement 2: EditUsingStoredProcedure
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Type: Stored procedure call with DECLARE/EXEC pattern
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Type: Stored procedure call with DECLARE/EXEC pattern
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Type: Parameterized SELECT with date functions
-- ============================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate

-- ============================================================
-- Statement 5: FindAllProducts
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Type: Stored procedure call with EXEC
-- ============================================================
EXEC [dbo].[uspGetProductData];
