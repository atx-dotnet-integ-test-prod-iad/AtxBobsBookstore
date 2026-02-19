/*
================================================================================
POSTGRESQL FUNCTIONS MIGRATION SCRIPT
================================================================================
Migration: Microsoft SQL Server to PostgreSQL
Application: Bob's Bookstore .NET ADO Application
Target Schema: bobsbookstore_dbo

This script converts SQL Server stored procedures to PostgreSQL functions.
These functions are required by the migrated .NET application code to execute
database operations successfully.

CRITICAL: This script must be executed on the PostgreSQL database before the
.NET application can perform database operations.

Functions Created:
1. uspUpdateAuthorPersonalInfo - Updates author personal information
2. uspDeleteAuthor - Deletes an author by BusinessEntityID
3. uspGetProductData - Retrieves product data (returns result set)

================================================================================
*/

-- Set search path to use the bobsbookstore_dbo schema
SET search_path TO bobsbookstore_dbo, public;

-- ============================================================================
-- FUNCTION 1: uspUpdateAuthorPersonalInfo
-- ============================================================================
-- Original SQL Server Procedure:
-- Converts UPDATE statement with TRY-CATCH error handling
-- Returns: INTEGER (number of rows affected)
-- Parameters: 5 parameters for author personal information
-- ============================================================================

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
    -- Update author personal information
    UPDATE bobsbookstore_dbo.author 
    SET 
        NationalIDNumber = p_NationalIDNumber,
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
        -- Log error (replace with actual logging if available)
        RAISE NOTICE 'Error in uspUpdateAuthorPersonalInfo: %', SQLERRM;
        RAISE;
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo TO PUBLIC;

-- ============================================================================
-- FUNCTION 2: uspDeleteAuthor
-- ============================================================================
-- Original SQL Server Procedure:
-- Converts DELETE statement with row count validation and error handling
-- Returns: INTEGER (number of rows affected)
-- Parameters: 1 parameter (BusinessEntityID)
-- ============================================================================

CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspDeleteAuthor(
    p_BusinessEntityID INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- Delete author by BusinessEntityID
    DELETE FROM bobsbookstore_dbo.author
    WHERE BusinessEntityID = p_BusinessEntityID;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Check if the delete was successful
    IF v_rows_affected = 0 THEN
        RAISE EXCEPTION 'No author found with the provided BusinessEntityID: %', p_BusinessEntityID;
    END IF;
    
    -- Return the number of rows affected
    RETURN v_rows_affected;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error and re-raise
        RAISE NOTICE 'Error in uspDeleteAuthor: %', SQLERRM;
        RAISE;
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspDeleteAuthor TO PUBLIC;

-- ============================================================================
-- FUNCTION 3: uspGetProductData
-- ============================================================================
-- Original SQL Server Procedure:
-- Converts cursor-based result set to table-returning function
-- Returns: TABLE (ProductID, Name, ProductNumber, SafetyStockLevel)
-- Parameters: None
-- ============================================================================

CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspGetProductData()
RETURNS TABLE (
    ProductID INTEGER,
    Name VARCHAR(50),
    ProductNumber VARCHAR(25),
    SafetyStockLevel SMALLINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Return the result set directly (no cursor needed in PostgreSQL)
    RETURN QUERY
    SELECT
        p.ProductID,
        p.Name,
        p.ProductNumber,
        p.SafetyStockLevel
    FROM bobsbookstore_dbo.product p;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in uspGetProductData: %', SQLERRM;
        RAISE;
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspGetProductData TO PUBLIC;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================
-- Use these queries to verify the functions were created successfully
-- ============================================================================

-- List all created functions
SELECT 
    n.nspname AS schema_name,
    p.proname AS function_name,
    pg_get_function_arguments(p.oid) AS parameters,
    pg_get_function_result(p.oid) AS return_type
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'bobsbookstore_dbo'
  AND p.proname IN ('uspupdateauthorpersonalinfo', 'uspdeleteauthor', 'uspgetproductdata')
ORDER BY p.proname;

/*
================================================================================
DEPLOYMENT NOTES
================================================================================

1. PREREQUISITES:
   - PostgreSQL database instance must be created
   - Schema 'bobsbookstore_dbo' must exist
   - Tables 'author' and 'product' must exist with proper structure
   - Database user must have CREATE FUNCTION privileges

2. DEPLOYMENT STEPS:
   a. Connect to PostgreSQL database as a user with sufficient privileges
   b. Execute this script: psql -d database_name -f postgresql_functions_migration.sql
   c. Verify functions were created using the verification queries
   d. Test each function individually before application deployment

3. TESTING RECOMMENDATIONS:
   a. Test uspUpdateAuthorPersonalInfo with valid and invalid BusinessEntityID
   b. Test uspDeleteAuthor with existing and non-existing records
   c. Test uspGetProductData to ensure proper result set returned
   d. Verify error handling works correctly for edge cases

4. FUNCTION CALLING SYNTAX FROM APPLICATION:
   - Statement 1: SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo($1, $2, $3, $4, $5);
   - Statement 3: SELECT bobsbookstore_dbo.uspDeleteAuthor($1);
   - Statement 5: SELECT * FROM bobsbookstore_dbo.uspGetProductData();

5. DIFFERENCES FROM SQL SERVER:
   - PostgreSQL functions replace SQL Server stored procedures
   - CURSOR OUTPUT parameter converted to table-returning function
   - Error handling uses PostgreSQL EXCEPTION syntax instead of TRY-CATCH
   - @@ROWCOUNT replaced with GET DIAGNOSTICS ROW_COUNT
   - Functions must explicitly RETURN values (stored procedures don't in SQL Server)

6. PERFORMANCE CONSIDERATIONS:
   - These functions are straightforward and should perform well
   - Consider adding indexes on BusinessEntityID columns if not present
   - Monitor query execution plans after deployment

7. ROLLBACK PROCEDURE:
   If needed, drop functions with:
   DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspUpdateAuthorPersonalInfo;
   DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspDeleteAuthor;
   DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspGetProductData;

================================================================================
MIGRATION STATUS INTEGRATION
================================================================================

This script addresses the following partial exit criteria from the migration:

✓ Criterion 13 (Database operations execute successfully): PARTIAL → READY
  - Provides the PostgreSQL function implementations required by the application
  - Once deployed, enables runtime execution of all converted SQL statements

✓ Criterion 15 (Passes tests): PARTIAL → READY FOR TESTING
  - Enables functional testing of all 5 converted SQL statements
  - Provides database infrastructure for comprehensive testing

NEXT STEPS AFTER DEPLOYMENT:
1. Execute functional tests for all 5 SQL statements
2. Validate date function conversions (Statement 4) with edge cases
3. Compare results with SQL Server baseline
4. Document any behavioral differences observed

================================================================================
*/
