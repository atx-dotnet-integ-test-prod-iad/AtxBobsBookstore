-- ============================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Migration: MS SQL Server to PostgreSQL
-- Date: 2026-03-21
-- Total Statements: 5
-- ============================================================
-- This catalog documents ALL original MS SQL Server statements
-- extracted from the application source code for DMS conversion.
-- ============================================================

-- Statement 1
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure (line ~164)
-- Type: Stored procedure call (MS SQL EXEC syntax)
-- Description: Calls the uspUpdateAuthorPersonalInfo stored procedure
--              to update author personal information, capturing rows affected.
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql (line ~188)
-- Type: Simple SELECT query
-- Description: Retrieves all rows from the author table.
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql (line ~210)
-- Type: Stored procedure call (MS SQL EXEC syntax)
-- Description: Calls the uspDeleteAuthor stored procedure
--              to delete an author by BusinessEntityID, capturing rows affected.
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear (line ~230)
-- Type: Complex SELECT with date functions
-- Description: Selects authors by hire year with calculated age and formatted date.
--              Uses mixed-case column names from original MS SQL Server schema.
SELECT businessentityid, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Statement 5
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts (line ~35)
-- Type: Stored procedure call (MS SQL EXEC syntax)
-- Description: Calls the uspGetProductData stored procedure to retrieve all products.
EXEC [dbo].[uspGetProductData];
