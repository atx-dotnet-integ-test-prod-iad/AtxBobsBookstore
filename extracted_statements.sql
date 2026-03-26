-- =====================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET ADO Application
-- Extraction Date: 2026-03-26
-- Total Statements: 5
-- =====================================================
-- Verification: All .cs files in app/ directory were scanned.
-- SQL statements found ONLY in:
--   - app/Bookstore.Web/Controllers/AuthorsController.cs (4 statements)
--   - app/Bookstore.Web/Controllers/ProductsController.cs (1 statement)
-- No SQL statements found in:
--   - app/Bookstore.Web/Controllers/AddressController.cs
--   - app/Bookstore.Web/Controllers/CheckoutController.cs
--   - app/Bookstore.Web/Controllers/OrdersController.cs
--   - app/Bookstore.Web/Controllers/SearchController.cs
--   - app/Bookstore.Web/Controllers/ShoppingCartController.cs
--   - app/Bookstore.Web/Controllers/ResaleController.cs
--   - app/Bookstore.Web/Controllers/WishlistController.cs
--   - app/Bookstore.Data/Repositories/*.cs
-- =====================================================

-- Statement 1: AuthorsController.EditUsingStoredProcedure (line ~163)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Type: Stored Procedure Call with DECLARE/EXEC/SELECT pattern
-- Context: Called from Edit() action to update author personal info
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: AuthorsController.FindAllAuthorsEmbeddedSql (line ~187)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Type: Simple SELECT query
-- Context: Called from Index() action to list all authors
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: AuthorsController.DeleteAuthorEmbeddedSql (line ~208)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Type: Stored Procedure Call with DECLARE/EXEC/SELECT pattern
-- Context: Called from DeleteConfirmed() action to delete an author
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: AuthorsController.SelectAuthorsByHireYear (line ~228)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Type: SELECT with date functions (partially migrated to PostgreSQL syntax)
-- Context: Called from OtherAuthors() action to select authors by hire year
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Statement 5: ProductsController.FindAllProducts (line ~34)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Type: Stored Procedure Call (EXEC)
-- Context: Called from Index() action to list all products
EXEC [dbo].[uspGetProductData];
