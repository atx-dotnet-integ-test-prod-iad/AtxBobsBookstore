-- ============================================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application (SQL Server to PostgreSQL Migration)
-- Total Statements: 5
-- ============================================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method (line 165)
-- Description: Stored procedure call to update author personal info
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method (line 190)
-- Description: Simple SELECT all from Author table
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT * FROM Author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method (line 213)
-- Description: Stored procedure call to delete an author
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method (line 234)
-- Description: Complex SELECT with T-SQL functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts method (line 36)
-- Description: Stored procedure call to get product data
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
EXEC [dbo].[uspGetProductData];
