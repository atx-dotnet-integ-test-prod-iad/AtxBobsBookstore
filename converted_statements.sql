-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Conversion Tool: AWS DMS MCP Statement Conversion Tool
-- Original Database: Microsoft SQL Server
-- Target Database: PostgreSQL
-- ============================================================================

-- ============================================================================
-- Statement 1
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion Method: DMS_TOOL
-- Original MS SQL: EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- Converted PostgreSQL:
-- ============================================================================
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 2
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: DMS_TOOL
-- Original MS SQL: SELECT * FROM [dbo].[author]
-- Converted PostgreSQL:
-- ============================================================================
SELECT * FROM bobsusedbookstore_dbo.author;

-- ============================================================================
-- Statement 3
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: DMS_TOOL
-- Original MS SQL: EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
-- Converted PostgreSQL:
-- ============================================================================
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion Method: DMS_TOOL
-- Original MS SQL: SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.author WHERE YEAR(HireDate) = @HireDate
-- Converted PostgreSQL:
-- ============================================================================
SELECT businessentityid, aws_sqlserver_ext.conv_datetime_to_string('VARCHAR', 'DATETIME', modifieddate, 120) AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', birthdate::TIMESTAMP, clock_timestamp()::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;

-- ============================================================================
-- Statement 5
-- File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion Method: DMS_TOOL
-- Original MS SQL: EXEC [dbo].[uspGetProductData]
-- Converted PostgreSQL:
-- ============================================================================
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
