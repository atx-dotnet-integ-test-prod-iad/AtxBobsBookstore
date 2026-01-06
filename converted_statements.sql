-- =========================================================================
-- CONVERTED SQL STATEMENTS - POSTGRESQL
-- Microsoft SQL Server to PostgreSQL Migration
-- =========================================================================
-- Total Statements: 5
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (All statements)
-- Conversion Date: Step 2 of Migration Plan
-- =========================================================================
-- NOTE: All statements were attempted through DMS MCP tool but failed due
-- to metadata model creation errors. Manual conversions were applied based
-- on PostgreSQL best practices and stored procedure analysis.
-- See dms_conversion_failures.log for detailed DMS attempt documentation.
-- =========================================================================

-- -------------------------------------------------------------------------
-- Statement 1: Update Author Using Stored Procedure (CONVERTED)
-- -------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~159
-- Conversion: Replaced stored procedure call with direct UPDATE
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- -------------------------------------------------------------------------
UPDATE bobsbookstore_dbo.author
SET nationalidnumber = @NationalIDNumber,
    birthdate = @BirthDate,
    maritalstatus = @MaritalStatus,
    gender = @Gender
WHERE businessentityid = @BusinessEntityID;

-- -------------------------------------------------------------------------
-- Statement 2: Select All Authors (ALREADY COMPATIBLE)
-- -------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~178
-- Conversion: No changes needed - already PostgreSQL compatible
-- Parameters: None
-- -------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author

-- -------------------------------------------------------------------------
-- Statement 3: Delete Author Using Stored Procedure (CONVERTED)
-- -------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~198
-- Conversion: Replaced stored procedure call with direct DELETE
-- Parameters: @BusinessEntityID
-- -------------------------------------------------------------------------
DELETE FROM bobsbookstore_dbo.author
WHERE businessentityid = @BusinessEntityID;

-- -------------------------------------------------------------------------
-- Statement 4: Select Authors by Hire Year with Date Functions (CONVERTED)
-- -------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~218
-- Conversion: Replaced SQL Server date functions with PostgreSQL equivalents
-- Parameters: @HireDate (int - year value)
-- Key Changes:
--   - FORMAT() -> TO_CHAR()
--   - DATEDIFF(YEAR, ..., GETDATE()) -> DATE_PART('year', AGE(CURRENT_DATE, ...))
--   - DATEPART(YEAR, ...) -> DATE_PART('year', ...)
-- -------------------------------------------------------------------------
SELECT businessentityid, 
       TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, 
       DATE_PART('year', AGE(CURRENT_DATE, birthdate)) AS age 
FROM bobsbookstore_dbo.author 
WHERE DATE_PART('year', hiredate) = @HireDate;

-- -------------------------------------------------------------------------
-- Statement 5: Get Product Data Using Stored Procedure (CONVERTED)
-- -------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~31
-- Conversion: Replaced cursor-based stored procedure with direct SELECT
-- Parameters: None
-- Note: Original stored procedure returned a cursor, but C# code expects
--       a result set via SqlQueryRaw, so direct SELECT is appropriate
-- -------------------------------------------------------------------------
SELECT productid, name, productnumber, safetystocklevel 
FROM bobsbookstore_dbo.product;

-- =========================================================================
-- END OF CONVERTED STATEMENTS
-- =========================================================================
-- Summary:
-- - Total Statements Converted: 5
-- - Statements Already Compatible: 1 (Statement 2)
-- - Statements Requiring Conversion: 4 (Statements 1, 3, 4, 5)
-- - Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- - Schema: All references use bobsbookstore_dbo schema
-- - Column Names: All converted to lowercase per PostgreSQL convention
-- =========================================================================
