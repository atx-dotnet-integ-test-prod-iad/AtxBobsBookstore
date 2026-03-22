-- ============================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Date: 2026-03-22
-- Purpose: Comprehensive catalog of ALL SQL statements found
--          in the codebase, with original MS SQL versions for
--          DMS conversion and current code versions documented.
-- ============================================================

-- Statement 1: AuthorsController.cs - FindAllAuthorsEmbeddedSql()
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Context: SELECT query to retrieve all authors
-- Original MS SQL:
SELECT * FROM [dbo].[Author]
-- Current code (already partially converted):
-- SELECT * FROM bobsbookstore_dbo.author

-- Statement 2: AuthorsController.cs - SelectAuthorsByHireYear()
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Context: SELECT query with date functions, filtering by hire year
-- Original MS SQL:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Current code (already partially converted):
-- SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(NOW(), birthdate))::int AS age FROM bobsbookstore_dbo.author WHERE DATE_PART('year', hiredate) = @HireDate;

-- Statement 3: AuthorsController.cs - EditUsingStoredProcedure()
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Context: Stored procedure call to update author personal info
-- Original MS SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Current code (already partially converted):
-- SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 4: AuthorsController.cs - DeleteAuthorEmbeddedSql()
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Context: Stored procedure call to delete an author
-- Original MS SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Current code (already partially converted):
-- SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 5: ProductsController.cs - FindAllProducts()
-- File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Context: Stored procedure call to get all product data
-- Original MS SQL:
EXEC [dbo].[uspGetProductData];
-- Current code (already partially converted):
-- SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================
-- Additional Scan Results
-- ============================================================
-- Scanned ALL .cs files for SQL patterns:
--   SqlQueryRaw, ExecuteSqlRaw, ExecuteSqlRawAsync, FromSqlRaw,
--   SqlCommand, SqlConnection, SqlDataReader, "SELECT", "INSERT",
--   "UPDATE", "DELETE", "EXEC", "DECLARE"
-- 
-- Result: No additional SQL statements found beyond the 5 above.
-- All SQL statements are contained in:
--   - AuthorsController.cs (4 statements)
--   - ProductsController.cs (1 statement)
-- ============================================================
