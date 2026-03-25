-- ============================================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Date: 2026-03-25
-- Purpose: Comprehensive catalog of all SQL statements for DMS conversion
-- ============================================================================

-- Statement 1
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 165
-- Method: EditUsingStoredProcedure
-- Type: MS SQL Server stored procedure call using DECLARE/EXEC syntax
-- Context: Updates author personal information via stored procedure
-- ---------------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 189
-- Method: FindAllAuthorsEmbeddedSql
-- Type: Simple SELECT query
-- Context: Retrieves all authors from the author table
-- ---------------------------------------------------------------------------
SELECT * FROM "bobsbookstore_dbo"."author"

-- Statement 3
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 212
-- Method: DeleteAuthorEmbeddedSql
-- Type: MS SQL Server stored procedure call using DECLARE/EXEC syntax
-- Context: Deletes an author via stored procedure
-- ---------------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 232
-- Method: SelectAuthorsByHireYear
-- Type: SELECT query with PostgreSQL functions (TO_CHAR, DATE_PART, AGE)
-- Context: Selects authors by hire year with calculated age
-- ---------------------------------------------------------------------------
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_DATE, BirthDate))::int AS Age FROM "bobsbookstore_dbo"."author" WHERE DATE_PART('year', HireDate) = @HireDate;

-- Statement 5
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Line: 36
-- Method: FindAllProducts
-- Type: MS SQL Server stored procedure call using EXEC syntax
-- Context: Executes stored procedure to retrieve all product data
-- ---------------------------------------------------------------------------
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- Total Statements: 5
-- Files Affected: 2
--   - AuthorsController.cs (4 statements)
--   - ProductsController.cs (1 statement)
-- ============================================================================
