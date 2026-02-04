-- ============================================================================
-- SQL Statement Catalog for SQL Server to PostgreSQL Migration
-- BobsBookstore Application
-- ============================================================================
-- This file contains all SQL statements extracted from the application code
-- for conversion using the DMS MCP tool.
--
-- Total Statements: 5
-- - 2 SELECT queries
-- - 3 Stored procedure calls
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: FindAllAuthorsEmbeddedSql
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 187
-- Method: FindAllAuthorsEmbeddedSql()
-- Purpose: Retrieve all authors from the author table
-- Parameters: None
-- T-SQL Features: Basic SELECT
-- Schema: bobsbookstore_dbo
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author
-- ============================================================================


-- ============================================================================
-- STATEMENT 2: SelectAuthorsByHireYear
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 228
-- Method: SelectAuthorsByHireYear(int hireYear)
-- Purpose: Retrieve authors hired in a specific year with formatted date and age
-- Parameters: @HireDate (int)
-- T-SQL Features: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Schema: bobsbookstore_dbo
-- Notes: Uses multiple T-SQL specific date functions that need PostgreSQL equivalents
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- ============================================================================


-- ============================================================================
-- STATEMENT 3: EditUsingStoredProcedure
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 163
-- Method: EditUsingStoredProcedure(int businessEntityId, string nationalIdNumber, DateTime birthDate, string maritalStatus, string gender)
-- Purpose: Update author personal information using stored procedure
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- T-SQL Features: DECLARE, EXEC with output parameter, stored procedure call
-- Schema: dbo
-- Notes: Stored procedure call with output variable for rows affected
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- ============================================================================

-- Stored Procedure Definition: uspUpdateAuthorPersonalInfo
-- ============================================================================
-- Source File: db/bobsusedbooks.sql
-- Line Number: 5796
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
-- ============================================================================


-- ============================================================================
-- STATEMENT 4: DeleteAuthorEmbeddedSql
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 208
-- Method: DeleteAuthorEmbeddedSql(int businessEntityId)
-- Purpose: Delete an author using stored procedure
-- Parameters: @BusinessEntityID (int)
-- T-SQL Features: DECLARE, EXEC with output parameter, stored procedure call
-- Schema: dbo
-- Notes: Stored procedure call with output variable for rows affected
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- ============================================================================

-- Stored Procedure Definition: uspDeleteAuthor
-- ============================================================================
-- Source File: db/bobsusedbooks.sql
-- Line Number: 5337
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

        -- Check if the delete was successful
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No author found with the provided BusinessEntityID.', 16, 1);
            RETURN;
        END
    END TRY
    BEGIN CATCH
        -- Log the error and re-throw
        EXECUTE [dbo].[uspLogError];
        THROW;
    END CATCH;
END;
-- ============================================================================


-- ============================================================================
-- STATEMENT 5: FindAllProducts
-- ============================================================================
-- Source File: ProductsController.cs
-- Line Number: 34
-- Method: FindAllProducts()
-- Purpose: Retrieve all products using stored procedure
-- Parameters: None (Note: Original procedure uses OUTPUT cursor parameter)
-- T-SQL Features: EXEC, stored procedure call, cursor output
-- Schema: dbo
-- Notes: Stored procedure uses cursor output which is SQL Server specific
-- ============================================================================
EXEC [dbo].[uspGetProductData];
-- ============================================================================

-- Stored Procedure Definition: uspGetProductData
-- ============================================================================
-- Source File: db/bobsusedbooks.sql
-- Line Number: 5522
-- ============================================================================
CREATE PROCEDURE [dbo].[uspGetProductData]
    @my_cursor CURSOR VARYING OUTPUT
AS
BEGIN
    -- Open a cursor for the SELECT query
    SET @my_cursor = CURSOR FOR
    SELECT
        ProductID,
        Name,
        ProductNumber,
        SafetyStockLevel
    FROM dbo.Product;
    -- Open the cursor to make it available to the caller
    OPEN @my_cursor;
END;
-- ============================================================================


-- ============================================================================
-- SUMMARY OF SQL STATEMENTS
-- ============================================================================
-- Total Statements: 5
-- 
-- Simple SELECT Queries: 1
--   1. FindAllAuthorsEmbeddedSql
--
-- Complex SELECT Queries: 1
--   2. SelectAuthorsByHireYear (uses FORMAT, DATEDIFF, GETDATE, DATEPART)
--
-- Stored Procedure Calls: 3
--   3. EditUsingStoredProcedure (uspUpdateAuthorPersonalInfo)
--   4. DeleteAuthorEmbeddedSql (uspDeleteAuthor)
--   5. FindAllProducts (uspGetProductData with cursor output)
--
-- T-SQL Features to Convert:
-- - DECLARE statements
-- - EXEC with output parameters
-- - FORMAT function
-- - DATEDIFF function
-- - GETDATE function
-- - DATEPART function
-- - SET NOCOUNT ON
-- - BEGIN TRY/CATCH blocks
-- - RAISERROR
-- - @@ROWCOUNT
-- - CURSOR VARYING OUTPUT
-- - [dbo].[schema] notation
--
-- PostgreSQL Equivalents Needed:
-- - DECLARE → Similar in PostgreSQL
-- - EXEC → CALL or SELECT function()
-- - FORMAT → TO_CHAR
-- - DATEDIFF → DATE_PART or AGE
-- - GETDATE → CURRENT_TIMESTAMP or NOW()
-- - DATEPART → EXTRACT or DATE_PART
-- - BEGIN TRY/CATCH → EXCEPTION blocks
-- - RAISERROR → RAISE EXCEPTION
-- - @@ROWCOUNT → GET DIAGNOSTICS
-- - CURSOR → PostgreSQL cursors (different syntax)
-- ============================================================================
