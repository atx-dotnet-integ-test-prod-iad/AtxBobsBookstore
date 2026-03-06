-- =============================================================================
-- EXTRACTED SQL STATEMENTS - Original MS SQL Server Statements
-- Project: BobsBookstore - SQL Server to PostgreSQL Migration
-- Total Statements: 5
-- Extraction Date: 2026-03-06
-- Last Updated: 2026-03-06 (Step 1 retry)
-- =============================================================================
-- 
-- Search Coverage:
--   - All .cs files in app/Bookstore.Web/Controllers/
--   - All .cs files in app/Bookstore.Data/Repositories/
--   - All .cs files in app/Bookstore.Data/
--   - All .cs files in app/Bookstore.Domain/
--   - All .cs files in app/Bookstore.Web/Startup/
--   - All .cs files in app/Bookstore.Web/Helpers/
--
-- Files containing SQL statements:
--   - app/Bookstore.Web/Controllers/AuthorsController.cs (4 statements)
--   - app/Bookstore.Web/Controllers/ProductsController.cs (1 statement)
--
-- Files verified to have NO raw SQL statements:
--   - app/Bookstore.Data/Repositories/ (all use LINQ, no raw SQL)
--   - app/Bookstore.Data/ApplicationDbContext.cs (EF DbContext, no raw SQL)
--   - app/Bookstore.Data/SeedData.cs (no raw SQL)
--   - app/Bookstore.Web/Startup/ServicesSetup.cs (connection string only)
-- =============================================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs:~167)
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Context: Calls stored procedure to update author personal info
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs:~192)
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Context: Simple SELECT to retrieve all authors
-- Parameters: None
SELECT * FROM Author

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs:~210)
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Context: Calls stored procedure to delete an author
-- Parameters: @BusinessEntityID (int)
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs:~228)
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Context: SELECT with date formatting, age calculation, and date filtering
-- Parameters: @HireDate (int - year value)
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs:~36)
-- Source: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Context: Calls stored procedure to retrieve all product data
-- Parameters: None
EXEC [dbo].[uspGetProductData];
