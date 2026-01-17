-- =============================================
-- PostgreSQL Function Conversions
-- Converted from SQL Server Stored Procedures
-- =============================================
-- This file contains PostgreSQL function versions of the SQL Server stored procedures
-- used by the BobsBookstore application
-- =============================================

-- Function: uspUpdateAuthorPersonalInfo
-- Description: Updates author personal information
-- Returns: Number of rows affected
-- =============================================
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(
    p_BusinessEntityID INT,
    p_NationalIDNumber VARCHAR(15),
    p_BirthDate TIMESTAMP,
    p_MaritalStatus CHAR(1),
    p_Gender CHAR(1)
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INT;
BEGIN
    -- Update the Author table
    UPDATE bobsbookstore_dbo.author
    SET NationalIDNumber = p_NationalIDNumber,
        BirthDate = p_BirthDate,
        MaritalStatus = p_MaritalStatus,
        Gender = p_Gender
    WHERE BusinessEntityID = p_BusinessEntityID;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Return the number of rows affected
    RETURN v_rows_affected;
EXCEPTION
    WHEN OTHERS THEN
        -- Log error (equivalent to SQL Server's uspLogError)
        RAISE NOTICE 'Error updating author personal info: %', SQLERRM;
        RETURN -1;
END;
$$;

-- =============================================
-- Function: uspDeleteAuthor
-- Description: Deletes an author by BusinessEntityID
-- Returns: Number of rows affected (1 if successful, 0 if not found)
-- =============================================
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspDeleteAuthor(
    p_BusinessEntityID INT
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INT;
BEGIN
    -- Delete the author
    DELETE FROM bobsbookstore_dbo.author
    WHERE BusinessEntityID = p_BusinessEntityID;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Check if the delete was successful
    IF v_rows_affected = 0 THEN
        RAISE EXCEPTION 'No author found with the provided BusinessEntityID.';
    END IF;
    
    -- Return the number of rows affected
    RETURN v_rows_affected;
EXCEPTION
    WHEN OTHERS THEN
        -- Log error
        RAISE NOTICE 'Error deleting author: %', SQLERRM;
        RETURN -1;
END;
$$;

-- =============================================
-- Function: uspGetProductData
-- Description: Returns product data
-- Returns: Table with ProductID, Name, ProductNumber, SafetyStockLevel
-- Note: SQL Server version used OUTPUT cursor parameter, PostgreSQL uses RETURNS TABLE
-- =============================================
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspGetProductData()
RETURNS TABLE (
    ProductID INT,
    Name VARCHAR(50),
    ProductNumber VARCHAR(25),
    SafetyStockLevel INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.ProductID,
        p.Name,
        p.ProductNumber,
        p.SafetyStockLevel
    FROM bobsbookstore_dbo.product p;
END;
$$;

-- =============================================
-- Conversion Notes:
-- =============================================
-- 1. uspUpdateAuthorPersonalInfo:
--    - Converted from SQL Server stored procedure with parameters
--    - Returns INT (number of rows affected) instead of using OUTPUT parameter
--    - Error handling uses PostgreSQL exception handling instead of TRY/CATCH
--    - Application code expects: SELECT * FROM bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(...)
--
-- 2. uspDeleteAuthor:
--    - Converted from SQL Server stored procedure with parameters
--    - Returns INT (number of rows affected)
--    - Raises exception if no author found (similar to SQL Server RAISERROR)
--    - Application code expects: SELECT * FROM bobsbookstore_dbo.uspDeleteAuthor(...)
--
-- 3. uspGetProductData:
--    - Converted from SQL Server stored procedure with CURSOR OUTPUT parameter
--    - Returns TABLE instead of using cursor (PostgreSQL best practice)
--    - Application code expects: SELECT * FROM bobsbookstore_dbo.uspGetProductData()
--    - Returns result set directly, which is more efficient than cursors
--
-- =============================================
-- Equivalency Status:
-- =============================================
-- These functions are functionally equivalent to their SQL Server counterparts
-- with the following adaptations:
-- - Return values instead of OUTPUT parameters for scalar results
-- - Return TABLE instead of CURSOR for result sets
-- - Use PostgreSQL exception handling syntax
-- - Use PostgreSQL data types (VARCHAR instead of NVARCHAR, TIMESTAMP instead of DATETIME)
--
-- Application Integration:
-- - All application calls have been updated to: SELECT * FROM function_name(params)
-- - This syntax works for both scalar returns (returns single row with single column)
--   and table returns (returns result set)
-- =============================================
