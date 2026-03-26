-- Extracted SQL Statements from BobsBookstore Application
-- Source: SQL Server (MS SQL) - Original Forms
-- Extraction Date: 2026-03-26
-- Total Statements Found: 5
-- Files with SQL Statements: AuthorsController.cs, ProductsController.cs
-- Files Scanned with No SQL Statements: AddressController.cs, AuthenticationController.cs,
--   CheckoutController.cs, HomeController.cs, OrdersController.cs, ResaleController.cs,
--   SearchController.cs, ShoppingCartController.cs, WishlistController.cs,
--   AdminAreaControllerBase.cs, DashboardController.cs, ErrorController.cs,
--   InventoryController.cs, OffersController.cs, Admin/OrdersController.cs,
--   ReferenceDataController.cs, AddressRepository.cs, BookRepository.cs,
--   CustomerRepository.cs, OfferRepository.cs, OrderRepository.cs,
--   ReferenceDataRepository.cs, ShoppingCartRepository.cs

-- ============================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: ~165
-- Context: Stored procedure call to update author personal info
-- Original MS SQL Form:
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: ~189
-- Context: Simple SELECT to retrieve all authors
-- Original MS SQL Form:
-- ============================================================
SELECT * FROM [dbo].[Author]

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: ~212
-- Context: Stored procedure call to delete an author
-- Original MS SQL Form:
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: ~232
-- Context: SELECT with computed columns and WHERE clause filtering by hire year
-- Original MS SQL Form:
-- ============================================================
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;

-- ============================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Source Line: ~36
-- Context: Stored procedure call to get all product data
-- Original MS SQL Form:
-- ============================================================
EXEC [dbo].[uspGetProductData];
