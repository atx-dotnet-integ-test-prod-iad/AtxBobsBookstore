-- ============================================================
-- Converted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Purpose: Catalog of all original MS SQL and converted PostgreSQL statements
-- Generated: 2026-03-22
-- Updated: 2026-03-22 (Step 1 re-execution with fresh DMS attempts)
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: Metadata model creation failed - No objects were found according to specified selection rules
-- Note: All 5 statements were passed through DMS MCP tool (dms-mcp___statement_conversion_tool)
--       but all failed with the same metadata model creation error. Manual conversion applied
--       with lowercase schema object names per the transformation definition rules.
-- DMS Attempts: 2 rounds (original 2026-03-22T16:11-16:13, retry 2026-03-22T16:36-16:38)
-- ============================================================

-- ============================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~165
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- DMS Attempt 1 Timestamp: 2026-03-22T16:11:40.585824
-- DMS Attempt 2 Timestamp: 2026-03-22T16:36:51.266635
-- ============================================================
-- ORIGINAL (MS SQL):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~189
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- DMS Attempt 1 Timestamp: 2026-03-22T16:12:03.099975
-- DMS Attempt 2 Timestamp: 2026-03-22T16:37:14.799189
-- ============================================================
-- ORIGINAL (MS SQL):
-- SELECT * FROM [dbo].[Author]

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~212
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- DMS Attempt 1 Timestamp: 2026-03-22T16:12:25.523395
-- DMS Attempt 2 Timestamp: 2026-03-22T16:37:37.849433
-- ============================================================
-- ORIGINAL (MS SQL):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~232
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- DMS Attempt 1 Timestamp: 2026-03-22T16:12:48.666980
-- DMS Attempt 2 Timestamp: 2026-03-22T16:38:01.670873
-- Conversion Notes: CONVERT(VARCHAR(10), col, 120) -> TO_CHAR(col, 'YYYY-MM-DD HH24:MI:SS')
--                   DATEDIFF(YEAR, col, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_DATE, col))::INTEGER
--                   Schema objects converted to lowercase
-- ============================================================
-- ORIGINAL (MS SQL):
-- SELECT BusinessEntityID, CONVERT(VARCHAR(10), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEDIFF(YEAR, HireDate, GETDATE()) >= @HireDate

-- CONVERTED (PostgreSQL):
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, hiredate))::INTEGER >= @HireDate;

-- ============================================================
-- Statement 5: FindAllProducts
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~37
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules
-- DMS Attempt 1 Timestamp: 2026-03-22T16:13:10.984692
-- DMS Attempt 2 Timestamp: 2026-03-22T16:38:28.790777
-- ============================================================
-- ORIGINAL (MS SQL):
-- EXEC [dbo].[uspGetProductData];

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
