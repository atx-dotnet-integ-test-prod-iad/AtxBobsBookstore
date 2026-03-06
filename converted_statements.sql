-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET ADO Application
-- Date: 2026-03-06 (Re-processed via DMS MCP Tool)
-- Total Statements: 5
-- DMS Successes: 5 (All statements converted successfully)
-- DMS Failures: 0

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion Method: DMS_TOOL
-- DMS Timestamp: 2026-03-06T14:02:27.916233
-- DMS Status: success
-- DMS Model: sql-conversion-1772805750
-- Original: EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- Converted:
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion Method: DMS_TOOL
-- DMS Timestamp: 2026-03-06T14:04:03.952742
-- DMS Status: success
-- DMS Model: sql-conversion-1772805846
-- Original: SELECT * FROM Author
-- Converted:
SELECT * FROM bobsusedbookstore_dbo.author;

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion Method: DMS_TOOL
-- DMS Timestamp: 2026-03-06T14:05:17.571418
-- DMS Status: success
-- DMS Model: sql-conversion-1772805919
-- Original: EXEC dbo.uspDeleteAuthor @BusinessEntityID
-- Converted:
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion Method: DMS_TOOL
-- DMS Timestamp: 2026-03-06T14:06:51.989085
-- DMS Status: success (GenAI-assisted conversion)
-- DMS Model: sql-conversion-1772806014
-- DMS Note: DMS converted @HireDate parameter to HireDate (without @). Parameter marker preserved as @HireDate for ADO.NET parameterized query compatibility.
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate
-- Converted:
SELECT businessentityid, to_char(modifieddate, 'yyyy-MM-dd HH24:MI:SS') AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts method
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Conversion Method: DMS_TOOL
-- DMS Timestamp: 2026-03-06T14:08:05.865566
-- DMS Status: success
-- DMS Model: sql-conversion-1772806087
-- Original: EXEC [dbo].[uspGetProductData]
-- Converted:
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
