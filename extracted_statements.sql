-- ============================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- SQL Server to PostgreSQL Migration
-- Project: BobsBookstore
-- Total Statements: 5
-- Source Files: 2 (AuthorsController.cs, ProductsController.cs)
-- ============================================================

-- ============================================================
-- Statement 1 of 5
-- ============================================================
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Line: ~187
-- Type: SELECT (Inline SQL)
-- Description: Retrieves all authors from the Author table
--
-- Original MS SQL Server Statement:
-- SELECT * FROM [dbo].[Author]
--
-- Current PostgreSQL Statement (already in codebase):
-- SELECT * FROM bobsbookstore_dbo.author
-- ============================================================

-- Original MS SQL:
SELECT * FROM [dbo].[Author];

-- Current PG:
-- SELECT * FROM bobsbookstore_dbo.author;


-- ============================================================
-- Statement 2 of 5
-- ============================================================
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Line: ~163
-- Type: EXEC (Stored Procedure Call)
-- Description: Calls stored procedure to update author personal info
--
-- Original MS SQL Server Statement:
-- EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
--
-- Current PostgreSQL Statement (already in codebase):
-- CALL bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender)
-- ============================================================

-- Original MS SQL:
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;

-- Current PG:
-- CALL bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);


-- ============================================================
-- Statement 3 of 5
-- ============================================================
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Line: ~208
-- Type: EXEC (Stored Procedure Call)
-- Description: Calls stored procedure to delete an author by BusinessEntityID
--
-- Original MS SQL Server Statement:
-- EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
--
-- Current PostgreSQL Statement (already in codebase):
-- CALL bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID)
-- ============================================================

-- Original MS SQL:
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;

-- Current PG:
-- CALL bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);


-- ============================================================
-- Statement 4 of 5
-- ============================================================
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Line: ~228
-- Type: SELECT (Complex Inline SQL with functions)
-- Description: Selects authors by hire year with computed columns (formatted date and age)
--
-- Original MS SQL Server Statement:
-- SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate
--
-- Current PostgreSQL Statement (already in codebase):
-- SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
-- ============================================================

-- Original MS SQL:
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;

-- Current PG:
-- SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;


-- ============================================================
-- Statement 5 of 5
-- ============================================================
-- File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Line: ~34
-- Type: EXEC (Stored Procedure Call)
-- Description: Calls stored procedure/function to get all product data
--
-- Original MS SQL Server Statement:
-- EXEC [dbo].[uspGetProductData]
--
-- Current PostgreSQL Statement (already in codebase):
-- SELECT * FROM bobsbookstore_dbo.uspgetproductdata()
-- ============================================================

-- Original MS SQL:
EXEC [dbo].[uspGetProductData];

-- Current PG:
-- SELECT * FROM bobsbookstore_dbo.uspgetproductdata();


-- ============================================================
-- END OF EXTRACTED STATEMENTS CATALOG
-- Total Statements Extracted: 5
-- Files Scanned: All .cs files in sourceCode/app/
-- Additional SQL Statements Found: None
-- ============================================================
