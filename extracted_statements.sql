-- ====================================================================
-- EXTRACTED SQL STATEMENTS - Original MS SQL Server Syntax
-- Source: BobsBookstore .NET Application
-- Extraction Date: 2026-03-23
-- Total Statements: 5
-- ====================================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
-- Source file: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- Source file: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
SELECT * FROM dbo.Author

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- Source file: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
-- Source file: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE YEAR(HireDate) = @HireDate

-- Statement 5: FindAllProducts (ProductsController.cs)
-- Source file: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
EXEC [dbo].[uspGetProductData];
