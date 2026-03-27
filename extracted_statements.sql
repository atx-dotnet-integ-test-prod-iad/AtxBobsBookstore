-- Extracted SQL Statements from BobsBookstore Application
-- Source: Microsoft SQL Server to PostgreSQL Migration
-- Extraction Date: 2026-03-27
-- These are the ORIGINAL MS SQL Server statements (pre-migration versions)
-- Total Statements Found: 5
-- Files Scanned: All .cs files in app/ directory (Controllers, Repositories, SeedData, ApplicationDbContext, Startup, etc.)
-- Files with SQL: AuthorsController.cs (4 statements), ProductsController.cs (1 statement)
-- Additional files checked: All Repositories/*.cs (BookRepository, CustomerRepository, OrderRepository, OfferRepository,
--   AddressRepository, ReferenceDataRepository, ShoppingCartRepository), SeedData.cs, ApplicationDbContext.cs,
--   ServicesSetup.cs, all other Controllers - NO raw SQL found (repositories use LINQ/EF Core only)

-- ============================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Type: Stored procedure call with DECLARE/EXEC pattern and 5 parameters
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (nvarchar), @BirthDate (datetime), @MaritalStatus (nchar), @Gender (nchar)
-- C# Context: Used in Edit action via ExecuteSqlRawAsync
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Type: Simple SELECT query - retrieves all authors
-- Parameters: None
-- C# Context: Used in Index action via SqlQueryRaw<Author>
-- ============================================================
SELECT * FROM [dbo].[Author]

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Type: Stored procedure call with DECLARE/EXEC pattern and 1 parameter
-- Parameters: @BusinessEntityID (int)
-- C# Context: Used in DeleteConfirmed action via ExecuteSqlRawAsync
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Type: SELECT with SQL Server functions (CONVERT, DATEDIFF, GETDATE, YEAR)
-- Parameters: @HireYear (int)
-- C# Context: Used in OtherAuthors action via SqlQueryRaw<AuthorAgeResult>
-- SQL Server Functions Used: CONVERT(VARCHAR, ..., 120), DATEDIFF(YEAR, ..., GETDATE()), YEAR(...)
-- ============================================================
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireYear;

-- ============================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Type: Stored procedure execution (no parameters)
-- Parameters: None
-- C# Context: Used in Index action via SqlQueryRaw<Product>
-- ============================================================
EXEC [dbo].[uspGetProductData];
