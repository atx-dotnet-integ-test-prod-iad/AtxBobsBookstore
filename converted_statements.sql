-- =============================================================================
-- Converted SQL Statements Catalog
-- Project: BobsBookstore - SQL Server to PostgreSQL Migration
-- Description: Complete catalog of all original MS SQL statements and their
--              PostgreSQL conversions with conversion method documentation.
-- Total Statements: 5
-- DMS Tool Status: ALL 5 FAILED - Metadata model creation error
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5)
-- =============================================================================

-- =============================================================================
-- Statement 1: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- =============================================================================
-- Original MS SQL Server:
-- SELECT * FROM [dbo].[Author]
-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.author

-- =============================================================================
-- Statement 2: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- =============================================================================
-- Original MS SQL Server:
-- EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- =============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- =============================================================================
-- Original MS SQL Server:
-- EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- =============================================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- =============================================================================
-- Original MS SQL Server:
-- SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate
-- Converted PostgreSQL:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- =============================================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- =============================================================================
-- Original MS SQL Server:
-- EXEC [dbo].[uspGetProductData]
-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- =============================================================================
-- Conversion Notes:
-- All 5 statements were attempted through DMS MCP tool first (MANDATORY).
-- All 5 failed with: "Metadata model creation failed: No objects were found
--   according to the specified selection rules."
-- Manual conversion applied with lowercase schema object names per
--   DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA rules.
-- Schema mapping: [dbo] -> bobsbookstore_dbo (matching ApplicationDbContext.cs)
-- All object names converted to lowercase for PostgreSQL compatibility.
-- SQL Server EXEC stored procedure calls converted to PostgreSQL function calls.
-- SQL Server CONVERT/DATEDIFF/GETDATE/YEAR functions converted to PostgreSQL
--   TO_CHAR/EXTRACT/AGE/CURRENT_DATE equivalents.
-- =============================================================================
