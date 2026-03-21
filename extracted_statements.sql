-- ============================================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Purpose: Comprehensive inventory of all SQL statements for DMS migration
-- ============================================================================

-- Statement 1
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 165 (EditUsingStoredProcedure method)
-- Context: Stored procedure call to update author personal info with DECLARE/EXEC/SELECT pattern
-- Original SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 189 (FindAllAuthorsEmbeddedSql method)
-- Context: Simple SELECT to retrieve all authors
-- Original SQL:
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 212 (DeleteAuthorEmbeddedSql method)
-- Context: Stored procedure call to delete author with DECLARE/EXEC/SELECT pattern
-- Original SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 232 (SelectAuthorsByHireYear method)
-- Context: SELECT with PostgreSQL-style functions (partially converted but must go through DMS)
-- Original SQL:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Statement 5
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line: 36 (FindAllProducts method)
-- Context: Stored procedure call to get product data
-- Original SQL:
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- Total Statements: 5
-- All statements must be processed through DMS MCP tool for conversion
-- ============================================================================
