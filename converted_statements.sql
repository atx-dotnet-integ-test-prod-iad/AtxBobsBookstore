-- =============================================
-- SQL Statement Conversion Catalog
-- BobsBookstore ADO.NET Application
-- Microsoft SQL Server to PostgreSQL Migration
-- PostgreSQL Converted Statements
-- =============================================

-- Total SQL Statements Converted: 5
-- Conversion Date: 2025-01-23
-- Target Database: PostgreSQL

-- IMPORTANT NOTE: All statements were processed through DMS MCP tool first.
-- DMS tool returned errors for all statements due to missing metadata model objects.
-- Manual conversion applied after DMS failure, following PostgreSQL best practices.

-- =============================================
-- Statement 1: Update Author Personal Info (Stored Procedure Call)
-- =============================================
-- Original: EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- PostgreSQL Conversion: Replace stored procedure call with direct function call
-- Note: Stored procedures in PostgreSQL are called as SELECT statements returning values
-- =============================================
DO $$
DECLARE
    rows_affected INT;
BEGIN
    SELECT public.uspupdateauthorpersonalinfo(
        @BusinessEntityID::integer,
        @NationalIDNumber::varchar,
        @BirthDate::timestamp,
        @MaritalStatus::char,
        @Gender::char
    ) INTO rows_affected;
    
    -- Return result for compatibility
    RAISE NOTICE 'Rows affected: %', rows_affected;
END $$;

-- Alternative simpler approach (for ExecuteSqlRawAsync compatibility):
SELECT public.uspupdateauthorpersonalinfo(
    @BusinessEntityID::integer,
    @NationalIDNumber::varchar,
    @BirthDate::timestamp,
    @MaritalStatus::char,
    @Gender::char
) AS rows_affected;

-- =============================================
-- Statement 2: Find All Authors
-- =============================================
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- PostgreSQL Conversion: Schema name conversion from SQL Server to PostgreSQL
-- Note: SQL Server schema.table becomes PostgreSQL schema.table (lowercase preferred)
-- =============================================
SELECT * FROM bobsbookstore_dbo.author;

-- =============================================
-- Statement 3: Delete Author (Stored Procedure Call)
-- =============================================
-- Original: EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- PostgreSQL Conversion: Replace stored procedure call with function call
-- =============================================
DO $$
DECLARE
    rows_affected INT;
BEGIN
    SELECT public.uspdeleteauthor(@BusinessEntityID::integer) INTO rows_affected;
    RAISE NOTICE 'Rows affected: %', rows_affected;
END $$;

-- Alternative simpler approach (for ExecuteSqlRawAsync compatibility):
SELECT public.uspdeleteauthor(@BusinessEntityID::integer) AS rows_affected;

-- =============================================
-- Statement 4: Select Authors By Hire Year with Age Calculation
-- =============================================
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- PostgreSQL Conversion: Replace SQL Server functions with PostgreSQL equivalents
--   FORMAT() -> TO_CHAR()
--   DATEDIFF(YEAR, date1, date2) -> EXTRACT(YEAR FROM AGE(date2, date1))
--   GETDATE() -> CURRENT_TIMESTAMP or NOW()
--   DATEPART(YEAR, date) -> EXTRACT(YEAR FROM date)
-- =============================================
SELECT 
    BusinessEntityID, 
    TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
    EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- =============================================
-- Statement 5: Get All Products (Stored Procedure Call)
-- =============================================
-- Original: EXEC [dbo].[uspGetProductData]
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- PostgreSQL Conversion: Replace stored procedure execution with function call
-- Note: In PostgreSQL, procedures/functions are called via SELECT
-- =============================================
SELECT * FROM public.uspgetproductdata();

-- =============================================
-- End of SQL Statement Conversion Catalog
-- =============================================
