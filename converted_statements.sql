-- ============================================================================
-- Converted SQL Statements Catalog
-- Source: BobsBookstore .NET ADO Application
-- Migration: Microsoft SQL Server to PostgreSQL
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: Metadata model creation failed - No objects were found according to the specified selection rules.
-- ============================================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Converted to PostgreSQL function call with lowercase schema:
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Original MS SQL: SELECT * FROM [dbo].[Author]
-- Converted with lowercase schema and table names:
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Converted to PostgreSQL function call with lowercase schema:
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Original MS SQL: SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;
-- Converted with lowercase column names and PostgreSQL date functions:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- Converted to PostgreSQL function call with lowercase schema:
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
