-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Migration: MS SQL Server to PostgreSQL
-- Date: 2026-03-25
-- Description: Original MS SQL Server statements extracted for DMS conversion
-- Total Statements: 5
-- ============================================================================

-- Statement 1: FindAllAuthorsEmbeddedSql()
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Line: ~187 (string sql = ...)
-- Execution Method: _context.Database.SqlQueryRaw<Author>(sql)
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- Statement 2: EditUsingStoredProcedure()
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Line: ~163 (string sql = ...)
-- Execution Method: _context.Database.ExecuteSqlRawAsync(sql, params)
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 3: DeleteAuthorEmbeddedSql()
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Line: ~208 (string sql = ...)
-- Execution Method: _context.Database.ExecuteSqlRawAsync(sql, params)
-- Parameters: @BusinessEntityID
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear()
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Line: ~228 (string sql = ...)
-- Execution Method: _context.Database.SqlQueryRaw<AuthorAgeResult>(sql, params)
-- Parameters: @HireDate
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate

-- Statement 5: FindAllProducts()
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Line: ~34 (string sql = ...)
-- Execution Method: _context.Database.SqlQueryRaw<Product>(sql)
-- ============================================================================
EXEC [dbo].[uspGetProductData];
