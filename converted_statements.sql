-- ============================================================================
-- Converted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Purpose: Comprehensive catalog of all original and converted SQL statements
-- DMS Status: ALL 5 statements failed DMS conversion (Metadata model creation failed)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all statements)
-- ============================================================================

-- ============================================================================
-- Statement 1
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 165 (EditUsingStoredProcedure method)
-- DMS Status: FAILED - Metadata model creation failed: No objects were found
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Original MS SQL:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Converted PostgreSQL:
-- SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);


-- ============================================================================
-- Statement 2
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 189 (FindAllAuthorsEmbeddedSql method)
-- DMS Status: FAILED - Metadata model creation failed: No objects were found
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Original MS SQL:
-- SELECT * FROM bobsbookstore_dbo.author

-- Converted PostgreSQL:
-- SELECT * FROM bobsbookstore_dbo.author


-- ============================================================================
-- Statement 3
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 212 (DeleteAuthorEmbeddedSql method)
-- DMS Status: FAILED - Metadata model creation failed: No objects were found
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Original MS SQL:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Converted PostgreSQL:
-- SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);


-- ============================================================================
-- Statement 4
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 232 (SelectAuthorsByHireYear method)
-- DMS Status: FAILED - Metadata model creation failed: No objects were found
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Original MS SQL:
-- SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Converted PostgreSQL:
-- SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;


-- ============================================================================
-- Statement 5
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line: 36 (FindAllProducts method)
-- DMS Status: FAILED - Metadata model creation failed: No objects were found
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Original MS SQL:
-- EXEC [dbo].[uspGetProductData];

-- Converted PostgreSQL:
-- SELECT * FROM bobsbookstore_dbo.uspgetproductdata();


-- ============================================================================
-- Summary
-- Total Statements: 5
-- DMS Successfully Converted: 0
-- DMS Failed / Manual Conversion: 5
-- DMS Error: Metadata model creation failed: No objects were found according to
--            the specified selection rules.
-- ============================================================================
