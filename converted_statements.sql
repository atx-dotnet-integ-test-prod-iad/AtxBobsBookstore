-- ============================================================
-- CONVERTED SQL STATEMENTS FOR POSTGRESQL
-- ============================================================
-- This file contains all SQL statements converted from SQL Server
-- T-SQL to PostgreSQL syntax.
-- 
-- Conversion Method: Manual (after DMS MCP tool failure)
-- All statements were passed through DMS MCP tool first
-- Schema Name: bobsbookstore_dbo (preserved from original)
-- Total Statements: 5
-- ============================================================

-- ============================================================
-- STATEMENT 1: Update Author Personal Information
-- ============================================================
-- Original Statement: DECLARE @rowsAffected INT; EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender; SELECT @rowsAffected;
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR - Metadata model creation failed
-- Notes: Converted stored procedure call to PostgreSQL function call
--        Alternative UPDATE statement provided if stored procedure not migrated
-- ============================================================

-- Primary PostgreSQL version (assumes stored procedure migrated as function):
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    @BusinessEntityID, 
    @NationalIDNumber, 
    @BirthDate, 
    @MaritalStatus, 
    @Gender
);

-- Alternative version (direct UPDATE if stored procedure not available):
-- UPDATE bobsbookstore_dbo.author
-- SET 
--     nationalidnumber = @NationalIDNumber,
--     birthdate = @BirthDate,
--     maritalstatus = @MaritalStatus,
--     gender = @Gender,
--     modifieddate = CURRENT_TIMESTAMP
-- WHERE businessentityid = @BusinessEntityID;

-- ============================================================
-- STATEMENT 2: Select All Authors
-- ============================================================
-- Original Statement: SELECT * FROM bobsbookstore_dbo.author
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (No changes needed)
-- DMS Status: ERROR - Metadata model creation failed
-- Notes: Statement is already PostgreSQL-compatible
-- ============================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================
-- STATEMENT 3: Delete Author
-- ============================================================
-- Original Statement: DECLARE @rowsAffected INT; EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID; SELECT @rowsAffected;
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR - Metadata model creation failed
-- Notes: Converted stored procedure call to PostgreSQL function call
--        Alternative DELETE statement provided if stored procedure not migrated
-- ============================================================

-- Primary PostgreSQL version (assumes stored procedure migrated as function):
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Alternative version (direct DELETE if stored procedure not available):
-- DELETE FROM bobsbookstore_dbo.author
-- WHERE businessentityid = @BusinessEntityID;

-- ============================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ============================================================
-- Original Statement: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR - Metadata model creation failed
-- T-SQL to PostgreSQL Function Mappings:
--   FORMAT() -> TO_CHAR()
--   DATEDIFF(YEAR, ..., GETDATE()) -> DATE_PART('year', AGE(CURRENT_TIMESTAMP, ...))
--   DATEPART(YEAR, ...) -> EXTRACT(YEAR FROM ...)
--   GETDATE() -> CURRENT_TIMESTAMP
-- ============================================================
SELECT 
    BusinessEntityID, 
    TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
    DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ============================================================
-- STATEMENT 5: Get Product Data
-- ============================================================
-- Original Statement: EXEC [dbo].[uspGetProductData];
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR - Metadata model creation failed
-- Notes: Converted stored procedure call to PostgreSQL function call
--        Alternative SELECT statement provided if stored procedure not migrated
-- ============================================================

-- Primary PostgreSQL version (assumes stored procedure migrated as function):
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- Alternative version (direct SELECT if stored procedure not available):
-- SELECT * FROM bobsbookstore_dbo.product;

-- ============================================================
-- CONVERSION SUMMARY
-- ============================================================
-- Total Statements Converted: 5
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- DMS Tool Status: All failed with "Metadata model creation failed"
-- 
-- Key Conversions Applied:
-- 1. EXEC stored_procedure -> SELECT FROM stored_procedure_as_function()
-- 2. DECLARE @var / SELECT @var -> Direct return values or inline expressions
-- 3. FORMAT() -> TO_CHAR()
-- 4. DATEPART() -> EXTRACT()
-- 5. DATEDIFF() -> DATE_PART() with AGE()
-- 6. GETDATE() -> CURRENT_TIMESTAMP
-- 7. [dbo].[name] -> bobsbookstore_dbo.name (lowercase)
-- 
-- Schema Preservation:
-- - All references to bobsbookstore_dbo maintained (no DMS schema changes)
-- 
-- Notes for Implementation:
-- - Stored procedures must be migrated to PostgreSQL or replaced with direct SQL
-- - Parameter names (@param) work in PostgreSQL but positional parameters ($1, $2) also supported
-- - Column names will be lowercased by PostgreSQL unless quoted
-- - DateTime handling uses UTC timestamps (.ToUniversalTime() in C# code)
-- ============================================================
