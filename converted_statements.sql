-- ============================================================================
-- Converted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Purpose: Catalog of all SQL statements converted for PostgreSQL
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- (DMS tool failed for all statements - manual conversion applied)
-- Date: 2026-03-24
-- ============================================================================

-- Statement 1 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 163 (EditUsingStoredProcedure method)
-- Original: SELECT * FROM dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
-- Conversion: Removed dbo. schema prefix (PostgreSQL uses public schema by default), lowercase object names
SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 187 (FindAllAuthorsEmbeddedSql method)
-- Original: SELECT * FROM author
-- Conversion: Already lowercase, no schema prefix - compatible as-is
SELECT * FROM author;

-- Statement 3 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 208 (DeleteAuthorEmbeddedSql method)
-- Original: SELECT * FROM dbo.uspdeleteauthor(@BusinessEntityID);
-- Conversion: Removed dbo. schema prefix, lowercase object names
SELECT * FROM uspdeleteauthor(@BusinessEntityID);

-- Statement 4 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 228 (SelectAuthorsByHireYear method)
-- Original: SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
-- Conversion: Already uses PostgreSQL-native functions (TO_CHAR, EXTRACT, AGE, NOW, ::INT cast), all lowercase - compatible as-is
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5 (Converted)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 34 (FindAllProducts method)
-- Original: SELECT * FROM dbo.uspgetproductdata();
-- Conversion: Removed dbo. schema prefix, lowercase object names
SELECT * FROM uspgetproductdata();

-- ============================================================================
-- Conversion Summary:
-- Total Statements: 5
-- DMS Tool Conversions: 0 (all failed with metadata model creation error)
-- Manual Conversions: 5 (all with DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)
-- Changes Applied:
--   Statements 1, 3, 5: Removed dbo. schema prefix
--   Statement 2: No changes needed (already PostgreSQL compatible)
--   Statement 4: No changes needed (already uses PostgreSQL-native functions)
-- ============================================================================
