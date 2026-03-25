-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Migration: MS SQL Server to PostgreSQL
-- Date: 2026-03-25
-- ============================================================================
-- DMS Tool Status: ALL 5 conversions FAILED with metadata model creation error
-- DMS Migration Project: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- DMS Error (all statements): "Metadata model creation failed: No objects were
--   found according to the specified selection rules."
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Statement 1: FindAllAuthorsEmbeddedSql()
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Original MS SQL: SELECT * FROM bobsbookstore_dbo.author
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-25T08:45:51.647552
-- Manual Conversion: Already PostgreSQL-compatible with lowercase schema/table names.
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- Statement 2: EditUsingStoredProcedure()
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-25T08:46:29.424753
-- Manual Conversion: SQL Server DECLARE/EXEC/SELECT pattern converted to PostgreSQL
--   function call. [dbo].[uspUpdateAuthorPersonalInfo] converted to lowercase
--   bobsbookstore_dbo.uspupdateauthorpersonalinfo(). DECLARE @rowsAffected removed.
--   EXEC converted to SELECT function_name().
-- ============================================================================
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 3: DeleteAuthorEmbeddedSql()
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-25T08:46:52.506727
-- Manual Conversion: SQL Server DECLARE/EXEC/SELECT pattern converted to PostgreSQL
--   function call. [dbo].[uspDeleteAuthor] converted to lowercase
--   bobsbookstore_dbo.uspdeleteauthor().
-- ============================================================================
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear()
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Original MS SQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-25T08:47:16.866481
-- Manual Conversion: SQL Server functions converted to PostgreSQL equivalents:
--   FORMAT() -> TO_CHAR(), DATEDIFF(YEAR,...,GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_DATE,...))::INTEGER
--   DATEPART(YEAR,...) -> EXTRACT(YEAR FROM ...), Column names lowercased.
--   Table reference: Author -> bobsbookstore_dbo.author
-- ============================================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts()
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-25T08:47:40.826636
-- Manual Conversion: SQL Server EXEC converted to PostgreSQL SELECT * FROM function().
--   [dbo].[uspGetProductData] converted to lowercase
--   bobsbookstore_dbo.uspgetproductdata().
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
