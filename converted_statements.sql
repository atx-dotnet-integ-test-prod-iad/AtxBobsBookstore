-- ============================================================================
-- BobsBookstore SQL Statements Conversion Catalog
-- Purpose: Complete catalog of original MS SQL and converted PostgreSQL statements
-- Date: 2026-01-29
-- Total Statements: 6
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: FindAllAuthorsEmbeddedSql - Simple SELECT
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
-- ============================================================================

-- ORIGINAL MS SQL:
SELECT * FROM bobsbookstore_dbo.author

-- CONVERTED POSTGRESQL:
SELECT * FROM bobsbookstore_dbo.author

-- NOTES: 
-- - Schema name remains "bobsbookstore_dbo" as configured in ApplicationDbContext.cs
-- - Simple SELECT statement syntax is identical in PostgreSQL
-- - No SQL Server specific features requiring conversion
-- ============================================================================

-- ============================================================================
-- STATEMENT 2: DeleteAuthorEmbeddedSql - Stored Procedure Execution
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
-- ============================================================================

-- ORIGINAL MS SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- CONVERTED POSTGRESQL:
SELECT bobsbookstore_dbo.uspDeleteAuthor($1)

-- NOTES:
-- - PostgreSQL stored procedure calls use SELECT or CALL syntax
-- - Parameter changed from @BusinessEntityID to $1 (positional parameter)
-- - Schema prefix bobsbookstore_dbo maintained
-- - DECLARE and output variable handling removed (function returns value directly)
-- ============================================================================

-- ============================================================================
-- STATEMENT 3: EditUsingStoredProcedure - Stored Procedure Execution
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
-- ============================================================================

-- ORIGINAL MS SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- CONVERTED POSTGRESQL:
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo($1, $2, $3, $4, $5)

-- NOTES:
-- - PostgreSQL stored procedure calls use SELECT syntax
-- - Parameters changed from @ParamName to $1, $2, $3, $4, $5 (positional parameters)
-- - Schema prefix bobsbookstore_dbo maintained
-- - DECLARE and output variable handling removed (function returns value directly)
-- ============================================================================

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with SQL Server Functions
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
-- ============================================================================

-- ORIGINAL MS SQL:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- CONVERTED POSTGRESQL:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = $1;

-- NOTES:
-- - FORMAT() converted to TO_CHAR() with PostgreSQL format patterns
-- - 'yyyy-MM-dd HH:mm:ss' changed to 'YYYY-MM-DD HH24:MI:SS' (PostgreSQL format)
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) converted to DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate))
-- - GETDATE() converted to CURRENT_TIMESTAMP
-- - DATEPART(YEAR, HireDate) converted to EXTRACT(YEAR FROM HireDate)
-- - @HireDate parameter changed to $1 (positional parameter)
-- - Schema name bobsbookstore_dbo maintained
-- ============================================================================

-- ============================================================================
-- STATEMENT 5: uspUpdateAuthorPersonalInfo - Stored Procedure Definition
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
-- ============================================================================

-- ORIGINAL MS SQL:
CREATE PROCEDURE [dbo].[uspUpdateAuthorPersonalInfo]
    @BusinessEntityID [int], 
    @NationalIDNumber [nvarchar](15), 
    @BirthDate [datetime], 
    @MaritalStatus [nchar](1), 
    @Gender [nchar](1)
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE [dbo].[Author] 
        SET [NationalIDNumber] = @NationalIDNumber 
            ,[BirthDate] = @BirthDate 
            ,[MaritalStatus] = @MaritalStatus 
            ,[Gender] = @Gender 
        WHERE [BusinessEntityID] = @BusinessEntityID;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;

-- CONVERTED POSTGRESQL:
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(
    p_BusinessEntityID int,
    p_NationalIDNumber varchar(15),
    p_BirthDate timestamp,
    p_MaritalStatus char(1),
    p_Gender char(1)
)
RETURNS int
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected int;
BEGIN
    UPDATE bobsbookstore_dbo.Author
    SET NationalIDNumber = p_NationalIDNumber,
        BirthDate = p_BirthDate,
        MaritalStatus = p_MaritalStatus,
        Gender = p_Gender
    WHERE BusinessEntityID = p_BusinessEntityID;
    
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    RETURN v_rows_affected;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in uspUpdateAuthorPersonalInfo: %', SQLERRM;
        RETURN 0;
END;
$$;

-- NOTES:
-- - CREATE PROCEDURE changed to CREATE OR REPLACE FUNCTION
-- - Schema changed from [dbo] to bobsbookstore_dbo
-- - Parameters prefixed with p_ and use PostgreSQL syntax
-- - nvarchar(15) changed to varchar(15)
-- - nchar(1) changed to char(1)
-- - datetime changed to timestamp
-- - WITH EXECUTE AS CALLER removed (not needed in PostgreSQL)
-- - SET NOCOUNT ON removed (not needed in PostgreSQL)
-- - BEGIN TRY/CATCH changed to BEGIN/EXCEPTION block
-- - @@ROWCOUNT changed to GET DIAGNOSTICS with ROW_COUNT
-- - EXECUTE [dbo].[uspLogError] changed to RAISE NOTICE with SQLERRM
-- - Function returns int (rows affected)
-- - LANGUAGE plpgsql specified
-- ============================================================================

-- ============================================================================
-- STATEMENT 6: uspDeleteAuthor - Stored Procedure Definition
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
-- ============================================================================

-- ORIGINAL MS SQL:
CREATE PROCEDURE [dbo].[uspDeleteAuthor]
    @BusinessEntityID [int]
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM [dbo].[Author]
        WHERE [BusinessEntityID] = @BusinessEntityID;
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No author found with the provided BusinessEntityID.', 16, 1);
            RETURN;
        END
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
        THROW;
    END CATCH;
END;

-- CONVERTED POSTGRESQL:
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspDeleteAuthor(
    p_BusinessEntityID int
)
RETURNS int
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected int;
BEGIN
    DELETE FROM bobsbookstore_dbo.Author
    WHERE BusinessEntityID = p_BusinessEntityID;
    
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    IF v_rows_affected = 0 THEN
        RAISE EXCEPTION 'No author found with the provided BusinessEntityID.';
    END IF;
    
    RETURN v_rows_affected;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in uspDeleteAuthor: %', SQLERRM;
        RAISE;
END;
$$;

-- NOTES:
-- - CREATE PROCEDURE changed to CREATE OR REPLACE FUNCTION
-- - Schema changed from [dbo] to bobsbookstore_dbo
-- - Parameter prefixed with p_ and uses PostgreSQL syntax
-- - WITH EXECUTE AS CALLER removed (not needed in PostgreSQL)
-- - SET NOCOUNT ON removed (not needed in PostgreSQL)
-- - BEGIN TRY/CATCH changed to BEGIN/EXCEPTION block
-- - @@ROWCOUNT changed to GET DIAGNOSTICS with ROW_COUNT
-- - RAISERROR changed to RAISE EXCEPTION
-- - THROW changed to RAISE (re-throws exception)
-- - EXECUTE [dbo].[uspLogError] changed to RAISE NOTICE with SQLERRM
-- - Function returns int (rows affected)
-- - LANGUAGE plpgsql specified
-- ============================================================================

-- ============================================================================
-- CONVERSION SUMMARY:
-- Total Statements: 6
-- Successfully Converted by DMS: 0
-- Manually Converted After DMS Failure: 6
-- DMS Failure Reason: Metadata model creation failed (The selected objects were not found)
--
-- Key Conversions Applied:
-- 1. FORMAT() → TO_CHAR() with PostgreSQL format patterns
-- 2. DATEDIFF() → DATE_PART() with AGE()
-- 3. GETDATE() → CURRENT_TIMESTAMP
-- 4. DATEPART() → EXTRACT()
-- 5. @ParameterName → $N (positional parameters) or p_ParameterName (in functions)
-- 6. CREATE PROCEDURE → CREATE OR REPLACE FUNCTION
-- 7. BEGIN TRY/CATCH → BEGIN/EXCEPTION
-- 8. @@ROWCOUNT → GET DIAGNOSTICS ... ROW_COUNT
-- 9. RAISERROR → RAISE EXCEPTION
-- 10. THROW → RAISE
-- 11. [dbo] schema → bobsbookstore_dbo schema
-- 12. DECLARE @var INT → Variables declared in DECLARE section
-- 13. EXEC procedure → SELECT function() or CALL procedure()
-- ============================================================================
