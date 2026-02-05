-- ============================================================================
-- PostgreSQL Function Definitions for BobsBookstore Migration
-- ============================================================================
-- These functions replace the SQL Server stored procedures used in the application.
-- They must be created in the PostgreSQL database before the application can run.
-- ============================================================================

-- Function 1: uspUpdateAuthorPersonalInfo
-- Replaces SQL Server stored procedure [dbo].[uspUpdateAuthorPersonalInfo]
-- Updates author personal information and returns the number of rows affected
-- ============================================================================
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
    rows_affected INT;
BEGIN
    -- Update the Author table
    UPDATE bobsbookstore_dbo.author
    SET 
        NationalIDNumber = p_NationalIDNumber,
        BirthDate = p_BirthDate,
        MaritalStatus = p_MaritalStatus,
        Gender = p_Gender,
        ModifiedDate = CURRENT_TIMESTAMP
    WHERE BusinessEntityID = p_BusinessEntityID;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS rows_affected = ROW_COUNT;
    
    -- Return the count of rows affected
    RETURN rows_affected;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error and re-raise
        RAISE NOTICE 'Error updating author: %', SQLERRM;
        RAISE;
END;
$$;

-- ============================================================================
-- Function 2: uspDeleteAuthor
-- Replaces SQL Server stored procedure [dbo].[uspDeleteAuthor]
-- Deletes an author and returns the number of rows affected
-- ============================================================================
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspDeleteAuthor(
    p_BusinessEntityID INT
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    rows_affected INT;
BEGIN
    -- Delete from the Author table
    DELETE FROM bobsbookstore_dbo.author
    WHERE BusinessEntityID = p_BusinessEntityID;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS rows_affected = ROW_COUNT;
    
    -- Check if any rows were deleted
    IF rows_affected = 0 THEN
        RAISE EXCEPTION 'No author found with the provided BusinessEntityID: %', p_BusinessEntityID;
    END IF;
    
    -- Return the count of rows affected
    RETURN rows_affected;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error and re-raise
        RAISE NOTICE 'Error deleting author: %', SQLERRM;
        RAISE;
END;
$$;

-- ============================================================================
-- Function 3: uspGetProductData
-- Replaces SQL Server stored procedure [dbo].[uspGetProductData]
-- Returns product data as a table result set
-- ============================================================================
-- Note: The original SQL Server procedure used a cursor with OUTPUT parameter.
-- In PostgreSQL, we convert this to a table-returning function which is more
-- idiomatic and compatible with the application code pattern:
-- SELECT * FROM bobsbookstore_dbo.uspGetProductData()
-- ============================================================================
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspGetProductData()
RETURNS TABLE (
    ProductID INT,
    Name VARCHAR(50),
    ProductNumber VARCHAR(25),
    SafetyStockLevel SMALLINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Return the result set
    RETURN QUERY
    SELECT 
        p.ProductID,
        p.Name,
        p.ProductNumber,
        p.SafetyStockLevel
    FROM bobsbookstore_dbo.Product p
    ORDER BY p.ProductID;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error and re-raise
        RAISE NOTICE 'Error retrieving product data: %', SQLERRM;
        RAISE;
END;
$$;

-- ============================================================================
-- Grant Permissions (adjust role name as needed for your environment)
-- ============================================================================
-- Replace 'bookstore_app_role' with your actual application database role
-- GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo TO bookstore_app_role;
-- GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspDeleteAuthor TO bookstore_app_role;
-- GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspGetProductData TO bookstore_app_role;

-- ============================================================================
-- Verification Queries
-- ============================================================================
-- Use these queries to test the functions after creation:
--
-- Test uspUpdateAuthorPersonalInfo:
-- SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(1, '123456789', '1980-01-01', 'M', 'M');
--
-- Test uspDeleteAuthor:
-- SELECT bobsbookstore_dbo.uspDeleteAuthor(999);
--
-- Test uspGetProductData:
-- SELECT * FROM bobsbookstore_dbo.uspGetProductData();
-- ============================================================================

-- ============================================================================
-- Deployment Notes
-- ============================================================================
-- 1. Ensure the schema 'bobsbookstore_dbo' exists before creating these functions
-- 2. Ensure the 'author' and 'Product' tables exist in the bobsbookstore_dbo schema
-- 3. Adjust column names and data types if your schema differs from the migration
-- 4. Grant appropriate permissions to the application database user/role
-- 5. Test each function with sample data before deploying the application
-- ============================================================================
