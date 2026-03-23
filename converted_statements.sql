-- ====================================================================
-- CONVERTED SQL STATEMENTS - PostgreSQL Syntax
-- Source: BobsBookstore .NET Application
-- Conversion Date: 2026-03-23
-- Total Statements: 5
-- ====================================================================
-- DMS Tool: dms-mcp___statement_conversion_tool
-- DMS Migration Project: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- DMS Parameters: database_name=BobsBookstore, schema_name=dbo, region=us-east-1
--
-- DMS Conversion Status: All 5 statements FAILED with error:
--   "Metadata model creation failed: No objects were found according to
--    the specified selection rules."
-- DMS was attempted twice (2026-03-23T16:17 and 2026-03-23T16:39).
--
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Manual Conversion Rules Applied:
--   - Schema: dbo -> bobsbookstore_dbo
--   - Object names: PascalCase -> lowercase
--   - SQL Server functions: CONVERT -> TO_CHAR, DATEDIFF -> EXTRACT/AGE,
--     GETDATE() -> CURRENT_DATE, YEAR() -> EXTRACT(YEAR FROM ...)
--   - Stored procedures: EXEC [schema].[proc] -> SELECT schema.proc()
--   - Stored procedures with result: DECLARE/EXEC/SELECT pattern -> SELECT schema.proc()
-- ====================================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed (attempts: 2026-03-23T16:17:29, 2026-03-23T16:39:44)
-- Manual Conversion: Replaced DECLARE/EXEC/SELECT pattern with PostgreSQL function call using SELECT
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- Original MS SQL: SELECT * FROM dbo.Author
-- DMS Status: FAILED - Metadata model creation failed (attempts: 2026-03-23T16:17:41, 2026-03-23T16:39:58)
-- Manual Conversion: Replaced dbo schema with bobsbookstore_dbo, lowercase table name
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed (attempts: 2026-03-23T16:18:17, 2026-03-23T16:40:13)
-- Manual Conversion: Replaced DECLARE/EXEC/SELECT pattern with PostgreSQL function call using SELECT
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
-- Original MS SQL: SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE YEAR(HireDate) = @HireDate
-- DMS Status: FAILED - Metadata model creation failed (attempts: 2026-03-23T16:18:29, 2026-03-23T16:40:27)
-- Manual Conversion: CONVERT->TO_CHAR, DATEDIFF->EXTRACT/AGE, GETDATE()->CURRENT_DATE, YEAR()->EXTRACT, lowercase names, bobsbookstore_dbo schema
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs)
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED - Metadata model creation failed (attempts: 2026-03-23T16:18:46, 2026-03-23T16:40:41)
-- Manual Conversion: Replaced EXEC with SELECT * FROM function call pattern for PostgreSQL
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
