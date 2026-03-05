-- ============================================================================
-- Extracted SQL Statements - MS SQL Server to PostgreSQL Migration
-- Source: BobsBookstore Application
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure method (AuthorsController.cs)
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Type: Stored procedure call with DECLARE/EXEC/SELECT pattern
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: FindAllAuthorsEmbeddedSql method (AuthorsController.cs)
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Type: Simple SELECT query
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql method (AuthorsController.cs)
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Type: Stored procedure call with DECLARE/EXEC/SELECT pattern
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear method (AuthorsController.cs)
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Type: SELECT with SQL Server-specific functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: FindAllProducts method (ProductsController.cs)
-- File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Type: Simple stored procedure call
EXEC [dbo].[uspGetProductData];
