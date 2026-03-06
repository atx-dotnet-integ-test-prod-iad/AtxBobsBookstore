-- =============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- =============================================================================
-- This file contains all SQL statements converted through the DMS MCP tool
-- for the BobsBookstore .NET application migration from SQL Server to PostgreSQL.
-- =============================================================================
-- Total Statements Converted: 5
-- DMS Conversion Status: All 5 successfully converted
-- DMS Migration Project: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- Database: BobsUsedBookStore
-- Source Schema: dbo
-- Target Schema: bobsusedbookstore_dbo
-- Conversion Date: 2026-03-06
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Statement 1: EditUsingStoredProcedure - Update Author Personal Info
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~163
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- Original MS SQL: EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- -----------------------------------------------------------------------------
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- -----------------------------------------------------------------------------
-- Statement 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~187
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- Original MS SQL: SELECT * FROM dbo.Author
-- -----------------------------------------------------------------------------
SELECT * FROM bobsusedbookstore_dbo.author;

-- -----------------------------------------------------------------------------
-- Statement 3: DeleteAuthorEmbeddedSql - Delete Author
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~208
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- Original MS SQL: EXEC dbo.uspDeleteAuthor @BusinessEntityID;
-- -----------------------------------------------------------------------------
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- -----------------------------------------------------------------------------
-- Statement 4: SelectAuthorsByHireYear - Select Authors by Hire Year with Age Calculation
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~228
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- Original MS SQL: SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- -----------------------------------------------------------------------------
SELECT businessentityid, aws_sqlserver_ext.conv_datetime_to_string('VARCHAR(19)', 'DATETIME', modifieddate, 120) AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', birthdate::TIMESTAMP, clock_timestamp()::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate::TIMESTAMP) = @HireDate;

-- -----------------------------------------------------------------------------
-- Statement 5: FindAllProducts - Get Product Data via Function
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: ~34
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- Original MS SQL: SELECT * FROM dbo.uspGetProductData();
-- -----------------------------------------------------------------------------
SELECT * FROM bobsusedbookstore_dbo.uspgetproductdata();

-- =============================================================================
-- END OF CONVERTED STATEMENTS
-- =============================================================================
