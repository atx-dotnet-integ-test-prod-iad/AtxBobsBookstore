-- ============================================================================
-- Converted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Date: 2026-03-25
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5)
-- DMS Error: Metadata model creation failed - No objects found for selection rules
-- ============================================================================

-- Statement 1
-- Source File: AuthorsController.cs:165 (EditUsingStoredProcedure)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ---------------------------------------------------------------------------
-- ORIGINAL (MS SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2
-- Source File: AuthorsController.cs:189 (FindAllAuthorsEmbeddedSql)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ---------------------------------------------------------------------------
-- ORIGINAL (MS SQL Server):
-- SELECT * FROM "bobsbookstore_dbo"."author"
-- CONVERTED (PostgreSQL):
SELECT * FROM "bobsbookstore_dbo"."author"

-- Statement 3
-- Source File: AuthorsController.cs:212 (DeleteAuthorEmbeddedSql)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ---------------------------------------------------------------------------
-- ORIGINAL (MS SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4
-- Source File: AuthorsController.cs:232 (SelectAuthorsByHireYear)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ---------------------------------------------------------------------------
-- ORIGINAL (MS SQL Server):
-- SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_DATE, BirthDate))::int AS Age FROM "bobsbookstore_dbo"."author" WHERE DATE_PART('year', HireDate) = @HireDate;
-- CONVERTED (PostgreSQL):
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_DATE, birthdate))::int AS age FROM "bobsbookstore_dbo"."author" WHERE DATE_PART('year', hiredate) = @HireDate;

-- Statement 5
-- Source File: ProductsController.cs:36 (FindAllProducts)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ---------------------------------------------------------------------------
-- ORIGINAL (MS SQL Server):
-- EXEC [dbo].[uspGetProductData];
-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================================
-- Summary:
-- Total Statements: 5
-- DMS Successful Conversions: 0
-- Manual Conversions (DMS Failure): 5
-- ============================================================================
