-- ========================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- BobsBookstore - MS SQL Server to PostgreSQL Migration
-- ========================================
-- This file contains all SQL statements extracted from the .NET codebase
-- for conversion from MS SQL Server to PostgreSQL using the DMS MCP tool.
--
-- Files scanned:
--   Controllers: AuthorsController.cs, ProductsController.cs, AddressController.cs,
--                CheckoutController.cs, HomeController.cs, OrdersController.cs,
--                ResaleController.cs, SearchController.cs, ShoppingCartController.cs,
--                WishlistController.cs
--   Repositories: BookRepository.cs, OrderRepository.cs, ShoppingCartRepository.cs,
--                 AddressRepository.cs, CustomerRepository.cs, OfferRepository.cs,
--                 ReferenceDataRepository.cs
--   Data Layer: ApplicationDbContext.cs, SeedData.cs
--
-- Result: 5 SQL statements found (all in controllers using raw SQL)
--         All repository files use LINQ/EF Core only (no raw SQL)
-- ========================================

-- ========================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ========================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~163
-- Context: ExecuteSqlRawAsync - calls stored procedure to update author info
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Original MS SQL Server Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ========================================
-- STATEMENT 2: Find All Authors (Simple SELECT)
-- ========================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~187
-- Context: SqlQueryRaw - retrieves all authors
-- Parameters: None
-- Original MS SQL Server Statement:
SELECT * FROM Author

-- ========================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ========================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~208
-- Context: ExecuteSqlRawAsync - calls stored procedure to delete an author
-- Parameters: @BusinessEntityID (int)
-- Original MS SQL Server Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ========================================
-- STATEMENT 4: Select Authors By Hire Year (Complex SELECT with SQL Server functions)
-- ========================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~228
-- Context: SqlQueryRaw - complex query with date functions and formatting
-- Parameters: @HireDate (int)
-- Original MS SQL Server Statement:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ========================================
-- STATEMENT 5: Get Product Data (Stored Procedure Call)
-- ========================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~34
-- Context: SqlQueryRaw - calls stored procedure to get all products
-- Parameters: None
-- Original MS SQL Server Statement:
EXEC [dbo].[uspGetProductData];

-- ========================================
-- END OF EXTRACTED STATEMENTS
-- Total: 5 SQL statements extracted from 2 source files
-- ========================================
