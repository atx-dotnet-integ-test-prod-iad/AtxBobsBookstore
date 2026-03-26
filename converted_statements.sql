-- =====================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET ADO Application
-- Conversion Date: 2026-03-26
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5)
-- DMS Error: Metadata model creation failed - No objects found according to selection rules
-- Manual Conversion Rules Applied:
--   1. DECLARE/EXEC/SELECT patterns -> SELECT * FROM schema.function() pattern
--   2. EXEC [schema].[proc] -> SELECT * FROM schema.proc()
--   3. All schema object names (tables, columns, views, procedures) converted to lowercase
--   4. Schema prefix bobsbookstore_dbo used for PostgreSQL compatibility
-- =====================================================

-- Statement 1: AuthorsController.EditUsingStoredProcedure
-- Original (MS SQL): DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-26T13:17:09.733321
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion: MSSQL DECLARE/EXEC/SELECT pattern -> PostgreSQL SELECT FROM function() pattern with lowercase schema
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: AuthorsController.FindAllAuthorsEmbeddedSql
-- Original (MS SQL): SELECT * FROM bobsbookstore_dbo.author
-- DMS Status: FAILED - Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-26T13:17:34.182860
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion: Already PostgreSQL-compatible, lowercase schema applied/verified
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 3: AuthorsController.DeleteAuthorEmbeddedSql
-- Original (MS SQL): DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-26T13:17:59.212395
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion: MSSQL DECLARE/EXEC/SELECT pattern -> PostgreSQL SELECT FROM function() pattern with lowercase schema
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: AuthorsController.SelectAuthorsByHireYear
-- Original (MS SQL): SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
-- DMS Status: FAILED - Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-26T13:18:22.924063
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion: Applied lowercase to column names and aliases for PostgreSQL compatibility
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: ProductsController.FindAllProducts
-- Original (MS SQL): EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED - Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-26T13:18:46.445299
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion: MSSQL EXEC pattern -> PostgreSQL SELECT FROM function() pattern with lowercase schema
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
