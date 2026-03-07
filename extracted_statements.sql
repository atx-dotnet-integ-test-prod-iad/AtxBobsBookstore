-- ============================================================================
-- Extracted SQL Statements Catalog
-- Project: BobsBookstore - MS SQL Server to PostgreSQL Migration
-- Generated: 2026-03-07
-- ============================================================================
-- This file catalogs ALL SQL statements found in the codebase for DMS processing.
-- Each statement is documented with its source file, method, and line number.
-- ============================================================================

-- Statement 1
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: 163
-- Description: Calls stored procedure to update author personal info
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: 187
-- Description: Selects all authors from the author table
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 3
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: 208
-- Description: Calls stored procedure to delete an author
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: 228
-- Description: Selects authors by hire year with age calculation
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5
-- Source: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: 34
-- Description: Calls stored procedure to get all product data
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================================
-- Total SQL Statements Extracted: 5
-- Files Scanned: All .cs files in app/ directory
-- No additional SQL statements were found in other files.
-- ============================================================================
