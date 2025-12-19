-- ================================================================
-- CONVERTED SQL STATEMENTS - PostgreSQL
-- SQL Server to PostgreSQL Migration
-- ================================================================
-- This file contains all SQL statements converted to PostgreSQL syntax
-- All statements were first attempted through DMS MCP tool
-- Manual conversions applied after DMS failures
-- ================================================================

-- ================================================================
-- STATEMENT 1: Update Author Using Stored Procedure
-- ================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs (line 163)
-- Method: EditUsingStoredProcedure
-- ================================================================
DO $$
DECLARE
    rows_affected INT;
BEGIN
    CALL bobsbookstore_dbo.uspupdateauthorpersonalinfo(
        p_businessentityid := @BusinessEntityID,
        p_nationalidnumber := @NationalIDNumber,
        p_birthdate := @BirthDate,
        p_maritalstatus := @MaritalStatus,
        p_gender := @Gender,
        p_rowsaffected := rows_affected
    );
    SELECT rows_affected;
END $$;

-- ================================================================
-- STATEMENT 2: Select All Authors
-- ================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs (line 187)
-- Method: FindAllAuthorsEmbeddedSql
-- Note: This statement is already PostgreSQL compatible
-- ================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ================================================================
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs (line 208)
-- Method: DeleteAuthorEmbeddedSql
-- ================================================================
DO $$
DECLARE
    rows_affected INT;
BEGIN
    CALL bobsbookstore_dbo.uspdeleteauthor(
        p_businessentityid := @BusinessEntityID,
        p_rowsaffected := rows_affected
    );
    SELECT rows_affected;
END $$;

-- ================================================================
-- STATEMENT 4: Select Authors by Hire Year with Date Functions
-- ================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs (line 228)
-- Method: SelectAuthorsByHireYear
-- ================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ================================================================
-- STATEMENT 5: Get All Products Using Stored Procedure
-- ================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Source: app/Bookstore.Web/Controllers/ProductsController.cs (line 32)
-- Method: FindAllProducts
-- ================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ================================================================
-- CONVERSION SUMMARY
-- ================================================================
-- Total Statements Converted: 5
-- DMS Tool Successful: 0
-- Manual Conversions: 5
--
-- Key Conversion Patterns Applied:
-- 1. DECLARE @var → DECLARE var (PostgreSQL doesn't use @)
-- 2. EXEC @return = [schema].[proc] → CALL schema.proc(..., OUT param)
-- 3. FORMAT(date, format) → TO_CHAR(date, format)
-- 4. DATEDIFF(YEAR, start, end) → DATE_PART('year', AGE(end, start))
-- 5. GETDATE() → CURRENT_TIMESTAMP
-- 6. DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
-- 7. EXEC [schema].[proc]; → SELECT * FROM schema.function();
-- 8. [schema].[object] → schema.object (brackets removed)
-- 9. All identifiers converted to lowercase (PostgreSQL convention)
--
-- Prerequisites:
-- The following stored procedures/functions must exist in PostgreSQL:
-- - bobsbookstore_dbo.uspupdateauthorpersonalinfo (procedure)
-- - bobsbookstore_dbo.uspdeleteauthor (procedure)
-- - bobsbookstore_dbo.uspgetproductdata (function)
-- ================================================================
