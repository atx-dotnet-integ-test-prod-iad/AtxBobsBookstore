-- ============================================================================
-- Converted SQL Statements Catalog - PostgreSQL
-- ============================================================================
-- Generated: Migration from Microsoft SQL Server to PostgreSQL
-- Conversion Method: Manual (after DMS tool metadata errors)
-- ============================================================================
-- This file contains all SQL statements converted to PostgreSQL syntax.
-- Each statement corresponds to an original statement in extracted_statements.sql
-- Conversion method: MANUAL_AFTER_DMS_FAILURE for all statements
-- ============================================================================

-- ============================================================================
-- CONVERTED STATEMENT 1: Update Author Personal Info using Stored Procedure
-- ============================================================================
-- Original Source: AuthorsController.cs - EditUsingStoredProcedure (line 155)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - objects not found
-- 
-- Changes Applied:
--   - DECLARE/EXEC pattern converted to SELECT function call
--   - Schema: dbo -> bobsbookstore_dbo
--   - Function name: uspUpdateAuthorPersonalInfo -> uspupdateauthorpersonalinfo (lowercase)
--   - Parameters: @Parameter syntax retained (Npgsql compatible)
-- ============================================================================
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    @BusinessEntityID, 
    @NationalIDNumber, 
    @BirthDate, 
    @MaritalStatus, 
    @Gender
);

-- ============================================================================
-- CONVERTED STATEMENT 2: Select All Authors
-- ============================================================================
-- Original Source: AuthorsController.cs - FindAllAuthorsEmbeddedSql (line 180)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - objects not found
--
-- Changes Applied:
--   - None - statement already PostgreSQL compatible
--   - Schema name bobsbookstore_dbo is correct
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- CONVERTED STATEMENT 3: Delete Author using Stored Procedure
-- ============================================================================
-- Original Source: AuthorsController.cs - DeleteAuthorEmbeddedSql (line 201)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - objects not found
--
-- Changes Applied:
--   - DECLARE/EXEC pattern converted to SELECT function call
--   - Schema: dbo -> bobsbookstore_dbo
--   - Function name: uspDeleteAuthor -> uspdeleteauthor (lowercase)
--   - Parameters: @Parameter syntax retained (Npgsql compatible)
-- ============================================================================
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- CONVERTED STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ============================================================================
-- Original Source: AuthorsController.cs - SelectAuthorsByHireYear (line 221)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - objects not found
--
-- Changes Applied:
--   - FORMAT() -> TO_CHAR() with PostgreSQL format string
--   - Format pattern: 'yyyy-MM-dd HH:mm:ss' -> 'YYYY-MM-DD HH24:MI:SS'
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) -> DATE_PART('year', AGE(CURRENT_DATE, BirthDate))
--   - GETDATE() -> CURRENT_DATE
--   - DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM HireDate)
--   - Schema name bobsbookstore_dbo already correct
-- ============================================================================
SELECT BusinessEntityID, 
       TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
       DATE_PART('year', AGE(CURRENT_DATE, BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ============================================================================
-- CONVERTED STATEMENT 5: Get All Product Data using Stored Procedure
-- ============================================================================
-- Original Source: ProductsController.cs - FindAllProducts (line 31)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - objects not found
--
-- Changes Applied:
--   - EXEC [dbo].[proc] -> SELECT * FROM schema.function()
--   - Schema: dbo -> bobsbookstore_dbo
--   - Function name: uspGetProductData -> uspgetproductdata (lowercase)
--   - Added () for function call syntax
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total Statements Converted: 5
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- DMS Tool Status: All conversions failed due to metadata model errors
-- 
-- Key Transformations:
--   1. T-SQL DECLARE/EXEC patterns -> PostgreSQL SELECT function calls
--   2. T-SQL date functions (FORMAT, DATEDIFF, DATEPART, GETDATE) -> PostgreSQL equivalents
--   3. Schema names: dbo -> bobsbookstore_dbo
--   4. Function/procedure names: PascalCase -> lowercase (PostgreSQL convention)
--   5. Parameter syntax: @Parameter (compatible with Npgsql)
-- ============================================================================
