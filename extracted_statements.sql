-- ============================================================================
-- Extracted SQL Statements - BobsBookstore SQL Server to PostgreSQL Migration
-- Generated: 2026-03-22
-- Total Statements: 5
-- ============================================================================

-- Statement 1: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Original MS SQL:
SELECT * FROM bobsbookstore_dbo.Author

-- Statement 2: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Original MS SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [bobsbookstore_dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Original MS SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [bobsbookstore_dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Original MS SQL:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.Author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Original MS SQL:
EXEC [bobsbookstore_dbo].[uspGetProductData];
