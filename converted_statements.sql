-- Converted SQL Statements Catalog
-- Source Database: Microsoft SQL Server
-- Target Database: PostgreSQL
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- Total Statements: 5
-- Conversion Date: 2026-03-06

-- ============================================================================
-- Statement 1: EditUsingStoredProcedure (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~163)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- Conversion Notes: SQL Server DECLARE/EXEC/SELECT pattern converted to PostgreSQL function call.
--   [dbo].[uspUpdateAuthorPersonalInfo] -> bobsbookstore_dbo.uspupdateauthorpersonalinfo (lowercase)
--   DECLARE @rowsAffected / EXEC @rowsAffected / SELECT @rowsAffected -> SELECT * FROM function()
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 2: FindAllAuthorsEmbeddedSql (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~187)
-- Original: SELECT * FROM "bobsbookstore_dbo"."author"
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- Conversion Notes: Already PostgreSQL-compatible. Schema/table names already lowercase.
--   No syntax changes needed.
-- ============================================================================
SELECT * FROM "bobsbookstore_dbo"."author"

-- ============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~208)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- Conversion Notes: SQL Server DECLARE/EXEC/SELECT pattern converted to PostgreSQL function call.
--   [dbo].[uspDeleteAuthor] -> bobsbookstore_dbo.uspdeleteauthor (lowercase)
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4: SelectAuthorsByHireYear (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~228)
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM "bobsbookstore_dbo"."author" WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- Conversion Notes:
--   FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') -> TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')
--   DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM CURRENT_DATE)::int - EXTRACT(YEAR FROM birthdate)::int
--   GETDATE() -> CURRENT_DATE
--   DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM hiredate)
--   Column names converted to lowercase: BusinessEntityID->businessentityid, etc.
-- ============================================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM CURRENT_DATE)::int - EXTRACT(YEAR FROM birthdate)::int AS age FROM "bobsbookstore_dbo"."author" WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================================
-- Statement 5: FindAllProducts (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs (line ~34)
-- Original: EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- Conversion Notes: SQL Server EXEC converted to PostgreSQL function call.
--   [dbo].[uspGetProductData] -> bobsbookstore_dbo.uspgetproductdata (lowercase)
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
