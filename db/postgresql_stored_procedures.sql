/*******************************************************************************
 * PostgreSQL Function Migrations
 * Converted from SQL Server Stored Procedures
 * Migration Date: 2026-02-03
 * 
 * This file contains PostgreSQL function equivalents for SQL Server stored 
 * procedures used in the BobsBookstore application.
 * 
 * Total Functions Created: 3
 * - uspUpdateAuthorPersonalInfo
 * - uspDeleteAuthor
 * - uspGetProductData
 ******************************************************************************/

-- =============================================================================
-- SCHEMA CREATION (if not exists)
-- =============================================================================
-- Ensure the schema exists before creating functions
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;
CREATE SCHEMA IF NOT EXISTS dbo;

-- =============================================================================
-- FUNCTION 1: uspUpdateAuthorPersonalInfo
-- =============================================================================
-- Purpose: Updates author personal information
-- Returns: Number of rows affected (INTEGER)
-- 
-- Original SQL Server Stored Procedure:
-- CREATE PROCEDURE [dbo].[uspUpdateAuthorPersonalInfo]
--     @BusinessEntityID [int], 
--     @NationalIDNumber [nvarchar](15), 
--     @BirthDate [datetime], 
--     @MaritalStatus [nchar](1), 
--     @Gender [nchar](1)
-- 
-- PostgreSQL Conversion Notes:
-- - Converted to a FUNCTION that returns INTEGER (rows affected)
-- - Uses RETURNS INTEGER instead of OUTPUT parameter
-- - Error handling converted from TRY/CATCH to EXCEPTION block
-- - Schema changed from [dbo] to bobsbookstore_dbo to match code references
-- - DATETIME converted to TIMESTAMP
-- - NVARCHAR/NCHAR converted to VARCHAR/CHAR (PostgreSQL handles Unicode natively)
-- =============================================================================

CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(
    p_BusinessEntityID INTEGER,
    p_NationalIDNumber VARCHAR(15),
    p_BirthDate TIMESTAMP,
    p_MaritalStatus CHAR(1),
    p_Gender CHAR(1)
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- Update the author record
    UPDATE bobsbookstore_dbo.author 
    SET NationalIDNumber = p_NationalIDNumber,
        BirthDate = p_BirthDate,
        MaritalStatus = p_MaritalStatus,
        Gender = p_Gender,
        ModifiedDate = CURRENT_TIMESTAMP
    WHERE BusinessEntityID = p_BusinessEntityID;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Return the number of rows affected
    RETURN v_rows_affected;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log the error (if uspLogError function exists)
        -- For now, re-raise the exception
        RAISE NOTICE 'Error in uspUpdateAuthorPersonalInfo: %', SQLERRM;
        RAISE;
END;
$$;

-- Add comment to the function
COMMENT ON FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo IS 
'Updates author personal information. Returns the number of rows affected.';

-- =============================================================================
-- FUNCTION 2: uspDeleteAuthor
-- =============================================================================
-- Purpose: Deletes an author by BusinessEntityID
-- Returns: Number of rows affected (INTEGER)
-- 
-- Original SQL Server Stored Procedure:
-- CREATE PROCEDURE [dbo].[uspDeleteAuthor]
--     @BusinessEntityID [int]
-- 
-- PostgreSQL Conversion Notes:
-- - Converted to a FUNCTION that returns INTEGER (rows affected)
-- - Uses RETURNS INTEGER instead of OUTPUT parameter
-- - Error handling converted from TRY/CATCH to EXCEPTION block
-- - Schema changed from [dbo] to bobsbookstore_dbo to match code references
-- - RAISERROR converted to RAISE EXCEPTION
-- - @@ROWCOUNT converted to GET DIAGNOSTICS ROW_COUNT
-- - THROW converted to RAISE
-- =============================================================================

CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspDeleteAuthor(
    p_BusinessEntityID INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- Delete the author record
    DELETE FROM bobsbookstore_dbo.author
    WHERE BusinessEntityID = p_BusinessEntityID;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Check if the delete was successful
    IF v_rows_affected = 0 THEN
        RAISE EXCEPTION 'No author found with the provided BusinessEntityID: %', p_BusinessEntityID
            USING ERRCODE = '02000'; -- no_data_found
    END IF;
    
    -- Return the number of rows affected
    RETURN v_rows_affected;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log the error (if uspLogError function exists)
        -- For now, re-raise the exception
        RAISE NOTICE 'Error in uspDeleteAuthor: %', SQLERRM;
        RAISE;
END;
$$;

-- Add comment to the function
COMMENT ON FUNCTION bobsbookstore_dbo.uspDeleteAuthor IS 
'Deletes an author by BusinessEntityID. Returns the number of rows affected. Raises exception if author not found.';

-- =============================================================================
-- FUNCTION 3: uspGetProductData
-- =============================================================================
-- Purpose: Retrieves product data
-- Returns: TABLE with product information
-- 
-- Original SQL Server Stored Procedure:
-- CREATE PROCEDURE [dbo].[uspGetProductData]
--     @my_cursor CURSOR VARYING OUTPUT
-- 
-- PostgreSQL Conversion Notes:
-- - Converted from cursor-based procedure to a RETURNS TABLE function
-- - PostgreSQL handles this more efficiently with set-based operations
-- - No cursor needed - can be called with SELECT * FROM function()
-- - Schema is dbo (not bobsbookstore_dbo) to match code references
-- - Returns all rows as a result set instead of cursor
-- - NVARCHAR converted to VARCHAR (PostgreSQL handles Unicode natively)
-- - SMALLINT remains SMALLINT (compatible)
-- =============================================================================

CREATE OR REPLACE FUNCTION dbo.uspGetProductData()
RETURNS TABLE (
    ProductID INTEGER,
    Name VARCHAR(100),
    ProductNumber VARCHAR(25),
    SafetyStockLevel SMALLINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Return the product data as a result set
    RETURN QUERY
    SELECT
        p.ProductID,
        p.Name,
        p.ProductNumber,
        p.SafetyStockLevel
    FROM dbo.Product p;
END;
$$;

-- Add comment to the function
COMMENT ON FUNCTION dbo.uspGetProductData IS 
'Retrieves product data including ProductID, Name, ProductNumber, and SafetyStockLevel. Call with SELECT * FROM dbo.uspGetProductData()';

-- =============================================================================
-- USAGE EXAMPLES
-- =============================================================================

-- Example 1: Update Author Personal Info
-- SELECT bobsbookstore_dbo.uspUpdateAuthorAuthorPersonalInfo(1, '123456789', '1980-01-01'::TIMESTAMP, 'M', 'M');

-- Example 2: Delete Author
-- SELECT bobsbookstore_dbo.uspDeleteAuthor(1);

-- Example 3: Get Product Data
-- SELECT * FROM dbo.uspGetProductData();

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

-- Verify functions were created successfully
SELECT 
    n.nspname AS schema_name,
    p.proname AS function_name,
    pg_get_function_result(p.oid) AS return_type,
    pg_get_function_arguments(p.oid) AS arguments
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE p.proname IN ('uspupdateauthorpersonalinfo', 'uspdeleteauthor', 'uspgetproductdata')
    AND n.nspname IN ('bobsbookstore_dbo', 'dbo')
ORDER BY n.nspname, p.proname;

/*******************************************************************************
 * DEPLOYMENT NOTES
 ******************************************************************************/
-- 
-- 1. Execute this script against the PostgreSQL database BEFORE running the 
--    migrated .NET application.
-- 
-- 2. Ensure the schemas (bobsbookstore_dbo and dbo) exist and contain the 
--    required tables (author, product) with the correct structure.
-- 
-- 3. If the tables are in different schemas, adjust the function definitions
--    accordingly.
-- 
-- 4. The application code has been updated to call these functions using:
--    - SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(...)
--    - SELECT bobsbookstore_dbo.uspDeleteAuthor(...)
--    - SELECT * FROM dbo.uspGetProductData()
-- 
-- 5. Test each function individually before running the full application.
-- 
-- 6. Consider adding appropriate indexes on BusinessEntityID columns for
--    optimal performance.
-- 
/*******************************************************************************
 * MIGRATION STATUS
 ******************************************************************************/
-- 
-- ✓ All 3 stored procedures have been converted to PostgreSQL functions
-- ✓ Error handling implemented using PostgreSQL EXCEPTION blocks
-- ✓ Return types changed from OUTPUT parameters to function return values
-- ✓ Cursor-based procedure converted to set-based table-returning function
-- ✓ Schema names match the application code references
-- ✓ Data types converted to PostgreSQL equivalents
-- 
-- RUNTIME TESTING REQUIRED:
-- - Test each function with sample data
-- - Verify error handling works as expected
-- - Confirm application can call these functions successfully
-- - Validate performance with production-like data volumes
-- 
/*******************************************************************************
 * END OF FILE
 ******************************************************************************/
