-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Conversion Date: 2026-03-05
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all statements)
-- DMS Error: Metadata model creation failed: The selected objects were not found.

-- ============================================================
-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion: DECLARE/EXEC stored procedure call → SELECT from PostgreSQL function
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================
-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- Conversion: Already PostgreSQL-compatible, lowercase schema applied
-- ============================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================
-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion: DECLARE/EXEC stored procedure call → SELECT from PostgreSQL function
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================
-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Conversion: FORMAT→TO_CHAR, DATEDIFF→EXTRACT+AGE, GETDATE→NOW, DATEPART→EXTRACT, lowercase columns
-- ============================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================
-- Statement 5: ProductsController.cs - FindAllProducts method
-- Original: EXEC [dbo].[uspGetProductData];
-- Conversion: EXEC stored procedure call → SELECT from PostgreSQL function
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
