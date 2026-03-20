-- ============================================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET ADO Application
-- Migration: Microsoft SQL Server to PostgreSQL
-- Total Statements: 5
-- Source Files: AuthorsController.cs (4 statements), ProductsController.cs (1 statement)
-- ============================================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure (line ~163)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Type: Stored Procedure Call (MS SQL DECLARE/EXEC pattern)
-- Current PostgreSQL: SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
-- Original MS SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql (line ~187)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Type: Simple SELECT query
-- Current PostgreSQL: SELECT * FROM bobsbookstore_dbo.author
-- Original MS SQL:
SELECT * FROM [dbo].[Author]

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql (line ~207)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Type: Stored Procedure Call (MS SQL DECLARE/EXEC pattern)
-- Current PostgreSQL: SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
-- Original MS SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear (line ~227)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Type: SELECT with date functions and aggregation
-- Current PostgreSQL: SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
-- Original MS SQL:
SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts (line ~34)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Type: Stored Procedure Call (MS SQL EXEC pattern)
-- Current PostgreSQL: SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
-- Original MS SQL:
EXEC [dbo].[uspGetProductData];
