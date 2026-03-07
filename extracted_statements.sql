-- ============================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application (MS SQL Server)
-- Date: 2026-03-07
-- Total Statements: 5
-- ============================================================

-- ============================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line ~163 (EditUsingStoredProcedure method)
-- Type: Stored Procedure Execution with DECLARE/EXEC pattern
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line ~189 (FindAllAuthorsEmbeddedSql method)
-- Type: Simple SELECT query
-- ============================================================
SELECT * FROM dbo.Author;

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line ~207 (DeleteAuthorEmbeddedSql method)
-- Type: Stored Procedure Execution with DECLARE/EXEC pattern
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line ~226 (SelectAuthorsByHireYear method)
-- Type: SELECT with DATEDIFF, FORMAT, DATEPART, GETDATE functions
-- ============================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Location: Line ~34 (FindAllProducts method)
-- Type: Stored Procedure Execution
-- ============================================================
EXEC [dbo].[uspGetProductData];
