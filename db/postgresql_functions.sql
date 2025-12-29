-- PostgreSQL Functions Migration Script
-- This script creates PostgreSQL equivalents of SQL Server stored procedures
-- Schema: bobsbookstore_dbo
-- Generated: 2024-12-29

-- =============================================================================
-- Function: uspupdateauthorpersonalinfo
-- Description: Updates author personal information
-- SQL Server Source: [dbo].[uspUpdateAuthorPersonalInfo]
-- =============================================================================
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    p_businessentityid INT,
    p_nationalidnumber VARCHAR(15),
    p_birthdate TIMESTAMP,
    p_maritalstatus CHAR(1),
    p_gender CHAR(1)
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INT;
BEGIN
    -- Update the author record
    UPDATE bobsbookstore_dbo.author
    SET nationalidnumber = p_nationalidnumber,
        birthdate = p_birthdate,
        maritalstatus = p_maritalstatus,
        gender = p_gender,
        modifieddate = CURRENT_TIMESTAMP
    WHERE businessentityid = p_businessentityid;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Return the number of rows affected
    RETURN v_rows_affected;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error (implement error logging as needed)
        RAISE NOTICE 'Error in uspupdateauthorpersonalinfo: %', SQLERRM;
        RETURN -1;
END;
$$;

-- =============================================================================
-- Function: uspdeleteauthor
-- Description: Deletes an author by BusinessEntityID
-- SQL Server Source: [dbo].[uspDeleteAuthor]
-- =============================================================================
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspdeleteauthor(
    p_businessentityid INT
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INT;
BEGIN
    -- Delete the author record
    DELETE FROM bobsbookstore_dbo.author
    WHERE businessentityid = p_businessentityid;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Check if any rows were deleted
    IF v_rows_affected = 0 THEN
        RAISE NOTICE 'No author found with the provided BusinessEntityID: %', p_businessentityid;
        RETURN 0;
    END IF;
    
    -- Return the number of rows affected
    RETURN v_rows_affected;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error (implement error logging as needed)
        RAISE NOTICE 'Error in uspdeleteauthor: %', SQLERRM;
        RETURN -1;
END;
$$;

-- =============================================================================
-- Function: uspgetproductdata
-- Description: Returns product data
-- SQL Server Source: [dbo].[uspGetProductData]
-- Note: Converted from cursor-based stored procedure to table-returning function
-- =============================================================================
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspgetproductdata()
RETURNS TABLE(
    productid INT,
    name VARCHAR(50),
    productnumber VARCHAR(25),
    safetystocklevel SMALLINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Return the product data as a table
    RETURN QUERY
    SELECT
        p.productid,
        p.name,
        p.productnumber,
        p.safetystocklevel
    FROM bobsbookstore_dbo.product p;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error (implement error logging as needed)
        RAISE NOTICE 'Error in uspgetproductdata: %', SQLERRM;
        RETURN;
END;
$$;

-- =============================================================================
-- Grant execute permissions (adjust schema/role as needed)
-- =============================================================================
-- GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo TO your_app_role;
-- GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspdeleteauthor TO your_app_role;
-- GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspgetproductdata TO your_app_role;

-- =============================================================================
-- Verification Queries
-- =============================================================================
-- To verify functions are created:
-- SELECT routine_name, routine_type 
-- FROM information_schema.routines 
-- WHERE routine_schema = 'bobsbookstore_dbo' 
-- AND routine_name IN ('uspupdateauthorpersonalinfo', 'uspdeleteauthor', 'uspgetproductdata');

-- =============================================================================
-- Migration Notes
-- =============================================================================
-- 1. SQL Server stored procedures with output cursors (uspGetProductData) have been 
--    converted to PostgreSQL table-returning functions
-- 2. Error handling uses PostgreSQL EXCEPTION blocks instead of TRY/CATCH
-- 3. @@ROWCOUNT replaced with GET DIAGNOSTICS ... ROW_COUNT
-- 4. Schema name is bobsbookstore_dbo (lowercase) per PostgreSQL convention
-- 5. All column names use lowercase to match PostgreSQL naming conventions
-- 6. Functions return INT for row counts (uspupdateauthorpersonalinfo, uspdeleteauthor)
-- 7. Function uspgetproductdata returns a table with product data
-- 8. ModifiedDate column is automatically updated in uspupdateauthorpersonalinfo
-- 9. Error logging calls ([dbo].[uspLogError]) removed - implement as needed
-- 10. All functions use LANGUAGE plpgsql for procedural logic
