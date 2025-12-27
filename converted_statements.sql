-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- SQL Server to PostgreSQL Migration
-- Source: BobsBookstore Application
-- Date: 2024-12-27
-- ============================================================================
-- This catalog contains all converted PostgreSQL SQL statements.
-- Each statement corresponds to an original statement in extracted_statements.sql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (DMS tool metadata model creation failed)
-- ============================================================================

-- ============================================================================
-- STATEMENT 1 (CONVERTED)
-- ============================================================================
-- SOURCE FILE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: 164
-- METHOD: EditUsingStoredProcedure
-- ORIGINAL TYPE: EXEC (Stored Procedure Call with DECLARE and variable)
-- CONVERTED TYPE: SELECT function call
-- CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5);

-- ============================================================================
-- STATEMENT 2 (CONVERTED)
-- ============================================================================
-- SOURCE FILE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: 188
-- METHOD: FindAllAuthorsEmbeddedSql
-- ORIGINAL TYPE: SELECT
-- CONVERTED TYPE: SELECT (no changes required)
-- CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3 (CONVERTED)
-- ============================================================================
-- SOURCE FILE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: 209
-- METHOD: DeleteAuthorEmbeddedSql
-- ORIGINAL TYPE: EXEC (Stored Procedure Call with DECLARE and variable)
-- CONVERTED TYPE: SELECT function call
-- CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================
SELECT bobsbookstore_dbo.uspdeleteauthor($1);

-- ============================================================================
-- STATEMENT 4 (CONVERTED)
-- ============================================================================
-- SOURCE FILE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: 229
-- METHOD: SelectAuthorsByHireYear
-- ORIGINAL TYPE: SELECT with SQL Server-specific functions
-- CONVERTED TYPE: SELECT with PostgreSQL functions
-- CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
-- CONVERSION NOTES:
--   - FORMAT() → TO_CHAR() with adjusted format string
--   - DATEDIFF(YEAR, ..., GETDATE()) → DATE_PART('year', AGE(NOW(), ...))
--   - DATEPART(YEAR, ...) → DATE_PART('year', ...)
--   - @HireDate → $1 (positional parameter)
-- ============================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(NOW(), BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE DATE_PART('year', HireDate) = $1;

-- ============================================================================
-- STATEMENT 5 (CONVERTED)
-- ============================================================================
-- SOURCE FILE: app/Bookstore.Web/Controllers/ProductsController.cs
-- LINE NUMBER: 32
-- METHOD: FindAllProducts
-- ORIGINAL TYPE: EXEC (Stored Procedure Call)
-- CONVERTED TYPE: SELECT FROM function call
-- CONVERSION METHOD: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Total Statements Converted: 5
-- 
-- Conversion Methods:
--   - DMS_TOOL: 0 (tool failed due to metadata model creation error)
--   - MANUAL_AFTER_DMS_FAILURE: 5 statements
--
-- Key Conversions Applied:
--   - EXEC stored_procedure → SELECT function_name()
--   - [dbo].[ProcedureName] → bobsbookstore_dbo.procedurename (lowercase)
--   - @ParameterName → $N (positional parameters)
--   - FORMAT(date, format) → TO_CHAR(date, 'PG_FORMAT')
--   - DATEDIFF(unit, start, end) → DATE_PART('unit', AGE(end, start))
--   - GETDATE() → NOW()
--   - DATEPART(unit, date) → DATE_PART('unit', date)
--
-- All statements have been manually converted following PostgreSQL best practices
-- and maintaining semantic equivalency with the original SQL Server statements.
-- ============================================================================
