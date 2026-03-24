-- ============================================================================
-- Extracted SQL Statements from BobsBookstore Application
-- Source: Microsoft SQL Server (MSSQL)
-- Extraction Date: 2026-03-24
-- Total Statements: 5
-- ============================================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method (line 163)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Description: Calls stored procedure uspUpdateAuthorPersonalInfo with parameters
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method (line 187)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Description: Simple SELECT all from Author table
SELECT * FROM Author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method (line 208)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Description: Calls stored procedure uspDeleteAuthor with BusinessEntityID parameter
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method (line 228)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Description: Complex SELECT with FORMAT, DATEDIFF, DATEPART, and GETDATE functions
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts method (line 34)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Description: Calls stored procedure uspGetProductData
EXEC [dbo].[uspGetProductData];
