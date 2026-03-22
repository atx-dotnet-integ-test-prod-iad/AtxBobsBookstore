-- ============================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- SQL Server to PostgreSQL Migration
-- Project: BobsBookstore
-- Total Statements: 5
-- Conversion Method: All 5 via DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Failed for all statements with: Metadata model creation failed -
--   No objects were found according to the specified selection rules.
-- ============================================================

-- ============================================================
-- Statement 1 of 5
-- ============================================================
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-22T05:38:17.615471
--
-- Original MS SQL:
-- SELECT * FROM [dbo].[Author]
--
-- Manual Conversion Rules Applied:
--   [dbo].[Author] -> bobsbookstore_dbo.author (lowercase schema + table name)
--
-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.author;


-- ============================================================
-- Statement 2 of 5
-- ============================================================
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-22T05:38:33.115669
--
-- Original MS SQL:
-- EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
--
-- Manual Conversion Rules Applied:
--   EXEC -> CALL
--   [dbo].[uspUpdateAuthorPersonalInfo] -> bobsbookstore_dbo.uspupdateauthorpersonalinfo (lowercase)
--   Parameters wrapped in parentheses for CALL syntax
--
-- Converted PostgreSQL:
CALL bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);


-- ============================================================
-- Statement 3 of 5
-- ============================================================
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-22T05:38:48.671484
--
-- Original MS SQL:
-- EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
--
-- Manual Conversion Rules Applied:
--   EXEC -> CALL
--   [dbo].[uspDeleteAuthor] -> bobsbookstore_dbo.uspdeleteauthor (lowercase)
--   Parameter wrapped in parentheses for CALL syntax
--
-- Converted PostgreSQL:
CALL bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);


-- ============================================================
-- Statement 4 of 5
-- ============================================================
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-22T05:39:04.027101
--
-- Original MS SQL:
-- SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate
--
-- Manual Conversion Rules Applied:
--   [dbo].[Author] -> bobsbookstore_dbo.author (lowercase schema + table)
--   BusinessEntityID -> businessentityid (lowercase column)
--   CONVERT(VARCHAR, ModifiedDate, 120) -> TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') (PG function equivalent)
--   FormattedModifiedDate -> formattedmodifieddate (lowercase alias)
--   DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INTEGER (PG equivalent)
--   Age -> age (lowercase alias)
--   YEAR(HireDate) -> EXTRACT(YEAR FROM hiredate) (PG equivalent)
--
-- Converted PostgreSQL:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;


-- ============================================================
-- Statement 5 of 5
-- ============================================================
-- File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-22T05:39:19.517604
--
-- Original MS SQL:
-- EXEC [dbo].[uspGetProductData]
--
-- Manual Conversion Rules Applied:
--   EXEC -> SELECT * FROM (PG function call syntax)
--   [dbo].[uspGetProductData] -> bobsbookstore_dbo.uspgetproductdata() (lowercase + function call syntax)
--
-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();


-- ============================================================
-- END OF CONVERTED STATEMENTS CATALOG
-- Total Statements Converted: 5
-- DMS Tool Successes: 0
-- DMS Tool Failures: 5 (all failed with metadata model creation error)
-- Manual Conversions (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA): 5
-- ============================================================
