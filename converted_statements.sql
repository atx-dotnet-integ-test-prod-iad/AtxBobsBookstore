-- ============================================================================
-- SQL Statement Conversion Catalog
-- Migration: Microsoft SQL Server to PostgreSQL
-- Conversion Method: DMS MCP Tool with Manual Fallback
-- Date: 2024
-- ============================================================================

-- ============================================================================
-- Statement ID: STMT_001
-- ============================================================================
-- Original Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Conversion Status: FAILED - Manual conversion applied
-- DMS Output:
-- {
--   "status": "error",
--   "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}\"}"
-- }

-- Manual Adjustment: YES
-- Manual Adjustment Reason:
-- DMS tool failed with metadata model creation error. This is a stored procedure call
-- that needs to be converted to a PostgreSQL function call. Since the stored procedure
-- doesn't exist in the PostgreSQL schema (it's SQL Server specific), this needs to be
-- converted to direct SQL UPDATE statement or a PostgreSQL function must be created.
-- For this migration, converting to direct UPDATE statement with RETURNING clause to get rows affected.

-- Converted Statement (PostgreSQL):
UPDATE bobsbookstore_dbo.author 
SET 
    nationalidnumber = @NationalIDNumber,
    birthdate = @BirthDate,
    maritalstatus = @MaritalStatus,
    gender = @Gender,
    modifieddate = CURRENT_TIMESTAMP
WHERE businessentityid = @BusinessEntityID
RETURNING 1;

-- ============================================================================
-- Statement ID: STMT_002
-- ============================================================================
-- Original Statement:
SELECT * FROM bobsbookstore_dbo.author

-- Conversion Status: FAILED - Manual conversion applied
-- DMS Output:
-- {
--   "status": "error",
--   "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}\"}"
-- }

-- Manual Adjustment: YES
-- Manual Adjustment Reason:
-- DMS tool failed with metadata model creation error. This is a simple SELECT statement
-- that is already PostgreSQL compatible. The schema name bobsbookstore_dbo is valid in PostgreSQL.
-- No syntax changes needed - statement is compatible as-is.

-- Converted Statement (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- Statement ID: STMT_003
-- ============================================================================
-- Original Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Conversion Status: FAILED - Manual conversion applied
-- DMS Output:
-- {
--   "status": "error",
--   "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}\"}"
-- }

-- Manual Adjustment: YES
-- Manual Adjustment Reason:
-- DMS tool failed with metadata model creation error. This is a stored procedure call for
-- deleting an author. Since the SQL Server stored procedure doesn't exist in PostgreSQL,
-- converting to direct DELETE statement with RETURNING clause to get rows affected.

-- Converted Statement (PostgreSQL):
DELETE FROM bobsbookstore_dbo.author 
WHERE businessentityid = @BusinessEntityID
RETURNING 1;

-- ============================================================================
-- Statement ID: STMT_004
-- ============================================================================
-- Original Statement:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Conversion Status: FAILED - Manual conversion applied
-- DMS Output:
-- {
--   "status": "error",
--   "error": "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}\"}"
-- }

-- Manual Adjustment: YES
-- Manual Adjustment Reason:
-- DMS tool failed with metadata model creation error. This SELECT statement contains
-- SQL Server specific functions that need PostgreSQL equivalents:
-- - FORMAT() -> TO_CHAR()
-- - DATEDIFF(YEAR, ..., GETDATE()) -> DATE_PART('year', AGE(..., CURRENT_DATE))
-- - GETDATE() -> CURRENT_DATE (for date calculations) or CURRENT_TIMESTAMP
-- - DATEPART(YEAR, ...) -> EXTRACT(YEAR FROM ...)

-- Converted Statement (PostgreSQL):
SELECT 
    businessentityid, 
    TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, 
    DATE_PART('year', AGE(CURRENT_DATE, birthdate)) AS age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================================
-- Conversion Summary Statistics
-- ============================================================================
-- Total SQL Statements: 4
-- DMS Successful Conversions: 0
-- DMS Failed Conversions: 4
-- Manual Conversions After DMS Failure: 4
-- ============================================================================
