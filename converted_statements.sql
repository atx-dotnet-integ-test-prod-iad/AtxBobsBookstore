-- ============================================================================
-- Converted SQL Statements - SQL Server to PostgreSQL
-- BobsBookstore Application
-- ============================================================================
-- This file contains all SQL statements converted from SQL Server T-SQL 
-- to PostgreSQL syntax.
--
-- Total Statements: 5
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- DMS Tool Status: All conversions failed with metadata model creation error
-- ============================================================================


-- ============================================================================
-- STATEMENT 1: FindAllAuthorsEmbeddedSql
-- ============================================================================
-- Source: AuthorsController.cs, Line 187
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Schema Transformations: None (bobsbookstore_dbo preserved)
-- ============================================================================

-- ORIGINAL (SQL Server):
-- SELECT * FROM bobsbookstore_dbo.author

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author
-- ============================================================================


-- ============================================================================
-- STATEMENT 2: SelectAuthorsByHireYear
-- ============================================================================
-- Source: AuthorsController.cs, Line 228
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Schema Transformations: None (bobsbookstore_dbo preserved)
-- T-SQL Functions Converted:
--   - FORMAT → TO_CHAR
--   - DATEDIFF → DATE_PART + AGE
--   - GETDATE → CURRENT_TIMESTAMP
--   - DATEPART → DATE_PART
-- ============================================================================

-- ORIGINAL (SQL Server):
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- CONVERTED (PostgreSQL):
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE DATE_PART('year', HireDate) = @HireDate;
-- ============================================================================


-- ============================================================================
-- STATEMENT 3: EditUsingStoredProcedure
-- ============================================================================
-- Source: AuthorsController.cs, Line 163
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Schema Transformations: [dbo] → dbo (square brackets removed)
-- Stored Procedure: uspUpdateAuthorPersonalInfo
-- ============================================================================

-- ORIGINAL (SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
-- Note: This is a DO block for inline execution. For application code, consider using SELECT function() if the procedure is converted to a function.
DO $$
DECLARE
    rowsAffected INT;
BEGIN
    CALL dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
    GET DIAGNOSTICS rowsAffected = ROW_COUNT;
    RAISE NOTICE '%', rowsAffected;
END $$;
-- ============================================================================


-- ============================================================================
-- STATEMENT 4: DeleteAuthorEmbeddedSql
-- ============================================================================
-- Source: AuthorsController.cs, Line 208
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Schema Transformations: [dbo] → dbo (square brackets removed)
-- Stored Procedure: uspDeleteAuthor
-- ============================================================================

-- ORIGINAL (SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
-- Note: This is a DO block for inline execution. For application code, consider using SELECT function() if the procedure is converted to a function.
DO $$
DECLARE
    rowsAffected INT;
BEGIN
    CALL dbo.uspDeleteAuthor(@BusinessEntityID);
    GET DIAGNOSTICS rowsAffected = ROW_COUNT;
    RAISE NOTICE '%', rowsAffected;
END $$;
-- ============================================================================


-- ============================================================================
-- STATEMENT 5: FindAllProducts
-- ============================================================================
-- Source: ProductsController.cs, Line 34
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Schema Transformations: [dbo] → dbo (square brackets removed)
-- Stored Procedure: uspGetProductData (replaced with direct SELECT)
-- Notes: Original procedure used CURSOR OUTPUT which is SQL Server specific.
--        Replaced with direct SELECT since procedure only returns simple result set.
-- ============================================================================

-- ORIGINAL (SQL Server):
-- EXEC [dbo].[uspGetProductData];

-- CONVERTED (PostgreSQL):
SELECT ProductID, Name, ProductNumber, SafetyStockLevel FROM dbo.Product;
-- ============================================================================


-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total Statements Converted: 5
-- 
-- Conversion Methods:
--   MANUAL_AFTER_DMS_FAILURE: 5 statements (100%)
--   DMS_TOOL: 0 statements (0%)
--
-- DMS Tool Status:
--   All 5 statements were passed through the DMS MCP tool as required.
--   All 5 statements failed with the same error:
--   "Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}"
--
-- Schema Transformations:
--   - bobsbookstore_dbo → bobsbookstore_dbo (no change)
--   - [dbo] → dbo (square brackets removed)
--
-- Key Conversions Applied:
--   1. T-SQL Functions:
--      - FORMAT → TO_CHAR (with format string adjustment)
--      - DATEDIFF → DATE_PART + AGE
--      - GETDATE → CURRENT_TIMESTAMP
--      - DATEPART → DATE_PART
--
--   2. Stored Procedures:
--      - EXEC procedure → CALL procedure OR SELECT FROM table
--      - DECLARE @variable → DECLARE variable (@ prefix removed)
--      - SELECT @variable → RAISE NOTICE (for output)
--      - [schema].[object] → schema.object (square brackets removed)
--
--   3. Cursor Elimination:
--      - CURSOR VARYING OUTPUT → Direct SELECT
--
-- Assumptions:
--   - Stored procedures (uspUpdateAuthorPersonalInfo, uspDeleteAuthor) 
--     have been separately converted to PostgreSQL procedures/functions
--   - Application code will be updated to handle parameter naming 
--     (removal of @ prefix)
--   - Result set handling adjusted from cursor to direct SELECT
--
-- Next Steps:
--   1. Validate SQL equivalency for all statement pairs
--   2. Integrate converted statements into application code
--   3. Verify stored procedure conversions in PostgreSQL database
--   4. Test all queries against PostgreSQL database
-- ============================================================================
