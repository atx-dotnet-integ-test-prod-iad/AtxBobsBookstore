-- ============================================================================
-- Converted SQL Statements - BobsBookstore SQL Server to PostgreSQL Migration
-- Generated: 2026-03-22
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5)
-- DMS Error: Metadata model creation failed: No objects were found according
--            to the specified selection rules. Please review your selection
--            rules and try again.
-- ============================================================================

-- Statement 1: FindAllAuthorsEmbeddedSql (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Original: SELECT * FROM bobsbookstore_dbo.Author
-- Conversion: Lowercase table name for PostgreSQL
SELECT * FROM bobsbookstore_dbo.author

-- Statement 2: EditUsingStoredProcedure (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [bobsbookstore_dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion: EXEC -> SELECT function call, lowercase schema objects
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 3: DeleteAuthorEmbeddedSql (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [bobsbookstore_dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion: EXEC -> SELECT function call, lowercase schema objects
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Original: SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.Author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
-- Conversion: Lowercase all schema object names (columns, table, aliases)
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts (Converted)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Original: EXEC [bobsbookstore_dbo].[uspGetProductData];
-- Conversion: EXEC -> SELECT * FROM function call, lowercase schema objects
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
