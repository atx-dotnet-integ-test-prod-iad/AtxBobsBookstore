-- ============================================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Purpose: Catalog of all SQL statements for DMS conversion
-- Date: 2026-03-24
-- ============================================================================

-- Statement 1
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 163 (EditUsingStoredProcedure method)
-- Context: Stored procedure call for updating author personal info, parameterized query
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
SELECT * FROM dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 187 (FindAllAuthorsEmbeddedSql method)
-- Context: Simple select query to retrieve all authors
-- Parameters: None
SELECT * FROM author;

-- Statement 3
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 208 (DeleteAuthorEmbeddedSql method)
-- Context: Stored procedure call for deleting an author, parameterized query
-- Parameters: @BusinessEntityID (int)
SELECT * FROM dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 228 (SelectAuthorsByHireYear method)
-- Context: Complex query with PostgreSQL-style functions (TO_CHAR, EXTRACT, AGE, NOW, type cast), parameterized query
-- Parameters: @HireDate (int)
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 34 (FindAllProducts method)
-- Context: Stored procedure call for getting all product data
-- Parameters: None
SELECT * FROM dbo.uspgetproductdata();

-- ============================================================================
-- Total Statements: 5
-- Files with SQL: 2 (AuthorsController.cs, ProductsController.cs)
-- Statement Types:
--   Stored Procedure Calls: 3 (Statements 1, 3, 5)
--   Simple SELECT: 1 (Statement 2)
--   Complex SELECT with functions: 1 (Statement 4)
-- ============================================================================
