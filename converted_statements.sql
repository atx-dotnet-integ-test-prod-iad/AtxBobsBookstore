-- ============================================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2026-03-24
-- DMS Retry Attempts: 3 (initial + 2 retries on 2026-03-24)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5)
-- DMS Error: Metadata model creation failed: No objects were found according
--            to the specified selection rules.
-- ============================================================================

-- Statement 1: FindAllAuthorsEmbeddedSql (converted)
-- Original MS SQL: SELECT * FROM Author
-- DMS Status: ERROR (latest retry 2026-03-24T17:02:38.556069)
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Conversion: Table name lowercased, schema mapped to bobsbookstore_dbo
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 2: EditUsingStoredProcedure (converted)
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: ERROR (latest retry 2026-03-24T17:03:02.517547)
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Conversion: SQL Server DECLARE/EXEC/SELECT pattern converted to PostgreSQL function call
--             Schema [dbo] mapped to bobsbookstore_dbo, procedure name lowercased
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 3: DeleteAuthorEmbeddedSql (converted)
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: ERROR (latest retry 2026-03-24T17:03:25.991930)
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Conversion: SQL Server DECLARE/EXEC/SELECT pattern converted to PostgreSQL function call
--             Schema [dbo] mapped to bobsbookstore_dbo, procedure name lowercased
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (converted)
-- Original MS SQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEPART(YEAR, HireDate) = @HireDate
-- DMS Status: ERROR (latest retry 2026-03-24T17:03:49.349243)
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Conversion: FORMAT -> TO_CHAR, DATEDIFF -> EXTRACT/AGE, DATEPART -> EXTRACT,
--             GETDATE() -> CURRENT_DATE, column/table names lowercased,
--             schema [dbo].[Author] mapped to bobsbookstore_dbo.author
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts (converted)
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- DMS Status: ERROR (latest retry 2026-03-24T17:04:11.836419)
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Conversion: SQL Server EXEC pattern converted to PostgreSQL SELECT * FROM function() call
--             Schema [dbo] mapped to bobsbookstore_dbo, procedure name lowercased
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
