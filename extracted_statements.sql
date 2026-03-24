-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Database: SQL Server -> PostgreSQL Migration
-- ============================================================================

-- ============================================================================
-- Statement 1
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~165
-- Type: Stored Procedure Call (T-SQL)
-- Context: Updates author personal info using stored procedure
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- Statement 2
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~189
-- Type: SELECT Query
-- Context: Retrieves all authors from the author table
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- Statement 3
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~212
-- Type: Stored Procedure Call (T-SQL)
-- Context: Deletes an author using stored procedure
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- Statement 4
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~232
-- Type: SELECT Query with PostgreSQL functions
-- Context: Selects authors by hire year with age calculation
-- ============================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ============================================================================
-- Statement 5
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~36
-- Type: Stored Procedure Call (T-SQL)
-- Context: Retrieves all product data using stored procedure
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- Total Statements Extracted: 5
-- Files Scanned: All .cs files in app/ directory
-- Additional files checked with no SQL found:
--   - app/Bookstore.Data/Repositories/*.cs (7 repository files)
--   - app/Bookstore.Web/Controllers/ (9 other controller files)
--   - app/Bookstore.Web/Areas/Admin/Controllers/*
--   - app/Bookstore.Data/ApplicationDbContext.cs
--   - app/Bookstore.Web/Startup/ServicesSetup.cs
-- ============================================================================
