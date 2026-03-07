-- ============================================================================
-- Converted SQL Statements Catalog
-- Project: BobsBookstore - MS SQL Server to PostgreSQL Migration
-- Generated: 2026-03-07
-- Conversion Tool: AWS DMS MCP Statement Conversion Tool
-- ============================================================================
-- All statements were converted using the DMS MCP tool.
-- CRITICAL: DMS changed schema from 'bobsbookstore_dbo' to 'bobsusedbookstore_dbo'
-- The original database name was 'BobsUsedBookStore' (not 'BobsBookstore')
-- ============================================================================

-- Statement 1 (DMS_TOOL - SUCCESS)
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: 163
-- Original MS SQL: EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- Converted PostgreSQL:
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2 (DMS_TOOL - SUCCESS)
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: 187
-- Original MS SQL: SELECT * FROM dbo.Author
-- Converted PostgreSQL:
SELECT * FROM bobsusedbookstore_dbo.author;

-- Statement 3 (DMS_TOOL - SUCCESS)
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: 208
-- Original MS SQL: EXEC dbo.uspDeleteAuthor @BusinessEntityID;
-- Converted PostgreSQL:
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4 (DMS_TOOL - SUCCESS)
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: 228
-- Original MS SQL: SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE YEAR(HireDate) = @HireDate;
-- Converted PostgreSQL:
SELECT businessentityid, aws_sqlserver_ext.conv_datetime_to_string('VARCHAR(19)', 'DATETIME', modifieddate, 120) AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', birthdate::TIMESTAMP, clock_timestamp()::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;

-- Statement 5 (DMS_TOOL - SUCCESS)
-- Source: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: 34
-- Original MS SQL: EXEC dbo.uspGetProductData;
-- Converted PostgreSQL:
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);

-- ============================================================================
-- Summary:
-- Total Statements Converted: 5
-- Successful DMS Conversions: 5
-- Manual Conversions: 0
-- ============================================================================
