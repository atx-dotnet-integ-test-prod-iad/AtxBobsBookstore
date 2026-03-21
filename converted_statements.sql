-- ============================================================
-- CONVERTED SQL STATEMENTS CATALOG (PostgreSQL)
-- Source: BobsBookstore .NET 8.0 Application
-- Target Database: PostgreSQL 13
-- Conversion Date: 2026-03-20
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Reason: DMS MCP tool failed for all 5 statements with error:
--   "Metadata model creation failed: No objects were found according to
--    the specified selection rules."
-- ============================================================

-- Statement 1: FindAllAuthorsEmbeddedSql (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion: No syntax changes needed (already PostgreSQL compatible with lowercase schema)
-- DMS Status: FAILED
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 2: EditUsingStoredProcedure (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion: DECLARE/EXEC/SELECT pattern → SELECT function() call
-- DMS Status: FAILED
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 3: DeleteAuthorEmbeddedSql (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion: DECLARE/EXEC/SELECT pattern → SELECT function() call
-- DMS Status: FAILED
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion: FORMAT→TO_CHAR, DATEDIFF(YEAR,...)→EXTRACT(YEAR FROM AGE(...)), GETDATE()→NOW(), DATEPART(YEAR,...)→EXTRACT(YEAR FROM ...)
-- DMS Status: FAILED
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Conversion: EXEC [dbo].[procedure] → SELECT * FROM schema.function()
-- DMS Status: FAILED
-- Original: EXEC [dbo].[uspGetProductData];
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
