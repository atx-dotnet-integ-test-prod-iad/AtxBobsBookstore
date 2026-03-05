-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Extraction Date: 2026-03-05

-- ============================================================
-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: EditUsingStoredProcedure method, line ~161
-- Type: Stored procedure call with DECLARE/EXEC pattern
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================
-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: FindAllAuthorsEmbeddedSql method, line ~183
-- Type: Simple SELECT query
-- ============================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================
-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: DeleteAuthorEmbeddedSql method, line ~200
-- Type: Stored procedure call with DECLARE/EXEC pattern
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================
-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: SelectAuthorsByHireYear method, line ~217
-- Type: SELECT with MS SQL-specific functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- ============================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================
-- Statement 5: ProductsController.cs - FindAllProducts method
-- File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Location: FindAllProducts method, line ~35
-- Type: Stored procedure EXEC call
-- ============================================================
EXEC [dbo].[uspGetProductData];
