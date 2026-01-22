-- ============================================================================
-- PostgreSQL Stored Procedures for BobsBookstore Migration
-- ============================================================================
-- This file contains PostgreSQL versions of the stored procedures referenced
-- in the BobsBookstore application after migration from SQL Server.
--
-- PREREQUISITES:
-- 1. PostgreSQL database instance must be running
-- 2. Schema bobsusedbookstore_dbo must exist
-- 3. Table bobsusedbookstore_dbo.author must exist with proper structure
-- 4. aws_sqlserver_ext extension must be installed (for complex queries)
--
-- INSTALLATION:
-- psql -h <host> -U <username> -d BobsUsedBookStore -f postgresql_stored_procedures.sql
-- ============================================================================

-- Ensure the schema exists
CREATE SCHEMA IF NOT EXISTS bobsusedbookstore_dbo;

-- ============================================================================
-- Stored Procedure: uspUpdateAuthorPersonalInfo
-- ============================================================================
-- Purpose: Updates personal information for an author
-- SQL Server Original: [dbo].[uspUpdateAuthorPersonalInfo]
-- PostgreSQL Converted: bobsusedbookstore_dbo.uspupdateauthorpersonalinfo
-- ============================================================================

CREATE OR REPLACE PROCEDURE bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(
    p_businessentityid INTEGER,
    p_nationalidnumber VARCHAR(15),
    p_birthdate TIMESTAMP,
    p_maritalstatus CHAR(1),
    p_gender CHAR(1)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update author personal information
    UPDATE bobsusedbookstore_dbo.author
    SET 
        nationalidnumber = p_nationalidnumber,
        birthdate = p_birthdate,
        maritalstatus = p_maritalstatus,
        gender = p_gender,
        modifieddate = CURRENT_TIMESTAMP  -- Auto-update modified date
    WHERE businessentityid = p_businessentityid;
    
    -- Check if any rows were updated
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No author found with BusinessEntityID: %', p_businessentityid
            USING ERRCODE = 'P0002';  -- no_data_found
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error and re-raise
        RAISE NOTICE 'Error in uspupdateauthorpersonalinfo: % %', SQLERRM, SQLSTATE;
        RAISE;
END;
$$;

-- Grant execute permission (adjust as needed)
-- GRANT EXECUTE ON PROCEDURE bobsusedbookstore_dbo.uspupdateauthorpersonalinfo TO your_app_user;

COMMENT ON PROCEDURE bobsusedbookstore_dbo.uspupdateauthorpersonalinfo IS 
'Updates personal information for an author. Converted from SQL Server stored procedure [dbo].[uspUpdateAuthorPersonalInfo].';


-- ============================================================================
-- Stored Procedure: uspDeleteAuthor
-- ============================================================================
-- Purpose: Deletes an author by BusinessEntityID
-- SQL Server Original: [dbo].[uspDeleteAuthor]
-- PostgreSQL Converted: bobsusedbookstore_dbo.uspdeleteauthor
-- ============================================================================

CREATE OR REPLACE PROCEDURE bobsusedbookstore_dbo.uspdeleteauthor(
    p_businessentityid INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- Delete the author
    DELETE FROM bobsusedbookstore_dbo.author
    WHERE businessentityid = p_businessentityid;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Check if the delete was successful
    IF v_rows_affected = 0 THEN
        RAISE EXCEPTION 'No author found with the provided BusinessEntityID: %', p_businessentityid
            USING ERRCODE = 'P0002';  -- no_data_found
    END IF;
    
    RAISE NOTICE 'Successfully deleted author with BusinessEntityID: %', p_businessentityid;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error and re-raise
        RAISE NOTICE 'Error in uspdeleteauthor: % %', SQLERRM, SQLSTATE;
        RAISE;
END;
$$;

-- Grant execute permission (adjust as needed)
-- GRANT EXECUTE ON PROCEDURE bobsusedbookstore_dbo.uspdeleteauthor TO your_app_user;

COMMENT ON PROCEDURE bobsusedbookstore_dbo.uspdeleteauthor IS 
'Deletes an author by BusinessEntityID. Converted from SQL Server stored procedure [dbo].[uspDeleteAuthor].';


-- ============================================================================
-- Verification Queries
-- ============================================================================
-- Run these queries to verify the stored procedures were created successfully

-- List all stored procedures in the schema
SELECT 
    routine_schema,
    routine_name,
    routine_type,
    data_type
FROM information_schema.routines
WHERE routine_schema = 'bobsusedbookstore_dbo'
    AND routine_type = 'PROCEDURE'
ORDER BY routine_name;

-- Show procedure details
SELECT 
    p.proname AS procedure_name,
    pg_get_function_arguments(p.oid) AS parameters,
    pg_get_functiondef(p.oid) AS definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'bobsusedbookstore_dbo'
    AND p.prokind = 'p'  -- 'p' for procedure
ORDER BY p.proname;


-- ============================================================================
-- Testing Examples
-- ============================================================================
-- IMPORTANT: Do NOT run these without adjusting the test data to match your database

/*
-- Test uspupdateauthorpersonalinfo
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(
    1,                              -- p_businessentityid
    '123456789',                    -- p_nationalidnumber
    '1980-01-15'::TIMESTAMP,        -- p_birthdate
    'M',                            -- p_maritalstatus
    'M'                             -- p_gender
);

-- Verify the update
SELECT * FROM bobsusedbookstore_dbo.author WHERE businessentityid = 1;

-- Test uspdeleteauthor (BE CAREFUL - this deletes data!)
-- First, ensure you have a test record or backup
CALL bobsusedbookstore_dbo.uspdeleteauthor(999);  -- Use a test ID

-- Verify the deletion
SELECT * FROM bobsusedbookstore_dbo.author WHERE businessentityid = 999;
*/


-- ============================================================================
-- Rollback Script (if needed)
-- ============================================================================
-- Use this to remove the stored procedures if needed

/*
DROP PROCEDURE IF EXISTS bobsusedbookstore_dbo.uspupdateauthorpersonalinfo;
DROP PROCEDURE IF EXISTS bobsusedbookstore_dbo.uspdeleteauthor;
*/


-- ============================================================================
-- Notes for Deployment
-- ============================================================================
-- 1. Review and adjust schema name if different in your environment
-- 2. Review and adjust column names to match your actual PostgreSQL schema
--    (all names have been converted to lowercase as per PostgreSQL conventions)
-- 3. Review and adjust data types if needed
-- 4. Test thoroughly in a non-production environment first
-- 5. Ensure proper permissions are granted to application users
-- 6. Monitor error logs after deployment
-- 7. Consider creating backup of existing procedures if any exist
-- ============================================================================
