-- Converted SQL Statements for PostgreSQL - BobsBookstore Application
-- Target: PostgreSQL
-- Conversion Date: 2026-03-26
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Attempts: 3 attempts total (2026-03-26T20:23:35, 2026-03-26T20:48:55, 2026-03-26T21:20:41)

-- ============================================================
-- Statement 1: EditUsingStoredProcedure (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion: SQL Server DECLARE/EXEC/SELECT pattern -> PostgreSQL SELECT FROM function() pattern
-- Schema: [dbo] -> bobsbookstore_dbo, stored procedure name lowercased
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Original MS SQL: SELECT * FROM [dbo].[Author]
-- Conversion: Schema [dbo] -> bobsbookstore_dbo, table name lowercased
-- ============================================================
SELECT * FROM bobsbookstore_dbo."author"

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion: SQL Server DECLARE/EXEC/SELECT pattern -> PostgreSQL SELECT FROM function() pattern
-- Schema: [dbo] -> bobsbookstore_dbo, stored procedure name lowercased
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Original MS SQL: SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;
-- Conversion: CONVERT -> TO_CHAR, DATEDIFF/GETDATE -> DATE_PART/AGE/CURRENT_TIMESTAMP, YEAR() -> DATE_PART('year', ...)
-- Column names lowercased, table name lowercased, schema [dbo] -> bobsbookstore_dbo
-- ============================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, birthdate))::integer AS age FROM bobsbookstore_dbo."author" WHERE DATE_PART('year', hiredate) = @HireDate;

-- ============================================================
-- Statement 5: FindAllProducts (Converted)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- Conversion: SQL Server EXEC -> PostgreSQL SELECT FROM function() pattern
-- Schema: [dbo] -> bobsbookstore_dbo, stored procedure name lowercased
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
