-- ============================================================================
-- BobsBookstore SQL Statements Extraction Catalog
-- Purpose: Complete catalog of all SQL statements for PostgreSQL migration
-- Date: 2026-01-29
-- Total Statements: 6
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: FindAllAuthorsEmbeddedSql - Simple SELECT
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 187
-- Method: FindAllAuthorsEmbeddedSql
-- Type: SELECT
-- Execution: SqlQueryRaw<Author>
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author
-- Parameters: None
-- Context: Retrieves all authors from the author table

-- ============================================================================
-- STATEMENT 2: DeleteAuthorEmbeddedSql - Stored Procedure Execution
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 205
-- Method: DeleteAuthorEmbeddedSql
-- Type: EXEC with DECLARE and OUTPUT
-- Execution: ExecuteSqlRawAsync
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Parameters: @BusinessEntityID (int)
-- Context: Deletes an author using stored procedure with output parameter

-- ============================================================================
-- STATEMENT 3: EditUsingStoredProcedure - Stored Procedure Execution
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 157
-- Method: EditUsingStoredProcedure
-- Type: EXEC with DECLARE and OUTPUT
-- Execution: ExecuteSqlRawAsync
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Context: Updates author personal information using stored procedure with output parameter

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with SQL Server Functions
-- File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 223
-- Method: SelectAuthorsByHireYear
-- Type: SELECT with FORMAT, DATEDIFF, GETDATE, DATEPART
-- Execution: SqlQueryRaw<AuthorAgeResult>
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Parameters: @HireDate (int)
-- Context: Complex SELECT requiring conversion of SQL Server specific functions to PostgreSQL equivalents

-- ============================================================================
-- STATEMENT 5: uspUpdateAuthorPersonalInfo - Stored Procedure Definition
-- File: sourceCode/db/adven.sql
-- Line: 932
-- Method: uspUpdateAuthorPersonalInfo
-- Type: CREATE PROCEDURE with UPDATE
-- Execution: Stored Procedure Definition
-- ============================================================================
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
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (nvarchar(15)), @BirthDate (datetime), @MaritalStatus (nchar(1)), @Gender (nchar(1))
-- Context: Stored procedure definition for updating author personal information

-- ============================================================================
-- STATEMENT 6: uspDeleteAuthor - Stored Procedure Definition
-- File: sourceCode/db/adven.sql
-- Line: 957
-- Method: uspDeleteAuthor
-- Type: CREATE PROCEDURE with DELETE
-- Execution: Stored Procedure Definition
-- ============================================================================
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
-- Parameters: @BusinessEntityID (int)
-- Context: Stored procedure definition for deleting an author

-- ============================================================================
-- SQL SERVER SPECIFIC FEATURES REQUIRING CONVERSION:
-- 1. FORMAT() function - needs TO_CHAR() in PostgreSQL
-- 2. DATEDIFF() function - needs date arithmetic or AGE() in PostgreSQL
-- 3. GETDATE() function - needs NOW() or CURRENT_TIMESTAMP in PostgreSQL
-- 4. DATEPART() function - needs EXTRACT() in PostgreSQL
-- 5. DECLARE variable syntax - needs PostgreSQL DECLARE syntax
-- 6. BEGIN TRY/CATCH blocks - needs PostgreSQL exception handling
-- 7. RAISERROR - needs RAISE in PostgreSQL
-- 8. @@ROWCOUNT - needs GET DIAGNOSTICS in PostgreSQL
-- 9. THROW - needs RAISE in PostgreSQL
-- 10. [dbo] schema references - may need schema adjustment
-- 11. Parameter syntax @ParamName - may need $1, $2 format in some contexts
-- ============================================================================
