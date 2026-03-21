-- ============================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Migration: MS SQL Server to PostgreSQL
-- Date: 2026-03-21
-- Total Statements: 5
-- ============================================================
-- All 5 statements were passed through the DMS MCP tool.
-- All 5 failed with: "Metadata model creation failed: No objects
-- were found according to the specified selection rules."
-- Manual conversion applied per DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA rules.
-- ============================================================

-- Statement 1 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects found
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion: MS SQL EXEC stored procedure -> PostgreSQL SELECT FROM function call with lowercase names
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects found
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- Conversion: Already PostgreSQL compatible, lowercase schema applied
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects found
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion: MS SQL EXEC stored procedure -> PostgreSQL SELECT FROM function call with lowercase names
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects found
-- Original: SELECT businessentityid, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
-- Conversion: Column names converted to lowercase for PostgreSQL compatibility
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5 (Converted)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects found
-- Original: EXEC [dbo].[uspGetProductData];
-- Conversion: MS SQL EXEC stored procedure -> PostgreSQL SELECT FROM function call with lowercase names
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
