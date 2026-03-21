-- ============================================================================
-- Converted SQL Statements Catalog
-- Target: PostgreSQL
-- Conversion Date: 2026-03-21
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5)
-- DMS Error: Metadata model creation failed: No objects were found according to
--            the specified selection rules. Please review your selection rules
--            and try again.
-- Note: All 5 statements were submitted to DMS MCP Tool. All failed with the
--       same metadata model creation error. Manual conversion was applied with
--       lowercase schema object names per PostgreSQL conventions.
--       Schema mapping: [dbo].[ObjectName] -> bobsbookstore_dbo.objectname
--       (Consistent with Entity Framework Core mappings in ApplicationDbContext.cs)
-- ============================================================================

-- ============================================================================
-- Statement 1: EditUsingStoredProcedure
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Input: EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-21T13:43:31.724547
-- DMS Error Timestamp: 2026-03-21T13:43:47.094556
-- Manual Conversion Rules Applied:
--   EXEC -> CALL
--   [dbo].[uspUpdateAuthorPersonalInfo] -> bobsbookstore_dbo.uspupdateauthorpersonalinfo
-- ============================================================================
CALL bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Input: SELECT * FROM [dbo].[Author];
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-21T13:43:55.721546
-- DMS Error Timestamp: 2026-03-21T13:44:10.391522
-- Manual Conversion Rules Applied:
--   [dbo].[Author] -> bobsbookstore_dbo.author
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Input: EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-21T13:44:21.633313
-- DMS Error Timestamp: 2026-03-21T13:44:36.620750
-- Manual Conversion Rules Applied:
--   EXEC -> CALL
--   [dbo].[uspDeleteAuthor] -> bobsbookstore_dbo.uspdeleteauthor
-- ============================================================================
CALL bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4: SelectAuthorsByHireYear
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Input: SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-21T13:44:45.814085
-- DMS Error Timestamp: 2026-03-21T13:45:00.395204
-- Manual Conversion Rules Applied:
--   CONVERT(VARCHAR(19), ModifiedDate, 120) -> TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')
--   DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER
--   YEAR(HireDate) -> EXTRACT(YEAR FROM hiredate)
--   [dbo].[Author] -> bobsbookstore_dbo.author
--   BusinessEntityID -> businessentityid (lowercase for PostgreSQL)
--   All column names lowercased for PostgreSQL compatibility
-- ============================================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================================
-- Statement 5: FindAllProducts
-- File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Input: EXEC [dbo].[uspGetProductData];
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-21T13:45:08.444701
-- DMS Error Timestamp: 2026-03-21T13:45:23.363679
-- Manual Conversion Rules Applied:
--   EXEC -> CALL
--   [dbo].[uspGetProductData] -> bobsbookstore_dbo.uspgetproductdata
--   Added cursor parameter for PostgreSQL stored procedure compatibility
-- ============================================================================
CALL bobsbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
