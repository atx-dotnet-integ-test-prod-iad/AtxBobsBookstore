-- ============================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Target: PostgreSQL
-- Date: 2026-03-07
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5)
-- ============================================================

-- ============================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- Schema Mapping: [dbo].[uspUpdateAuthorPersonalInfo] -> bobsusedbookstore_dbo.uspupdateauthorpersonalinfo
-- Notes: DECLARE/EXEC pattern converted to CALL; parameters passed directly
-- ============================================================
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- Schema Mapping: dbo.Author -> bobsbookstore_dbo.author
-- ============================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- Schema Mapping: [dbo].[uspDeleteAuthor] -> bobsusedbookstore_dbo.uspdeleteauthor
-- Notes: DECLARE/EXEC pattern converted to CALL; parameters passed directly
-- ============================================================
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- Schema Mapping: dbo.Author -> bobsbookstore_dbo.author
-- Function Mappings:
--   FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') -> to_char(modifieddate, 'YYYY-MM-DD HH24:MI:SS')
--   DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INT
--   DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM hiredate)
--   GETDATE() -> CURRENT_TIMESTAMP
--   Column names lowercased: BusinessEntityID -> businessentityid, etc.
-- ============================================================
SELECT businessentityid, to_char(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- Schema Mapping: [dbo].[uspGetProductData] -> bobsusedbookstore_dbo.uspgetproductdata
-- Notes: EXEC converted to CALL with cursor parameter for PostgreSQL stored procedure
-- ============================================================
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
