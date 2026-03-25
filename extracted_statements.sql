-- ============================================================================
-- Extracted SQL Statements from MS SQL Server .NET Application
-- Source: BobsBookstore Web Application
-- Total Statements: 5
-- ============================================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method (line ~163)
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method (line ~188)
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT * FROM Author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method (line ~207)
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method (line ~225)
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts method (line ~35)
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
EXEC [dbo].[uspGetProductData];
