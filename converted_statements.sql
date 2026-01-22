-- =========================================================================
-- CONVERTED SQL STATEMENTS - PostgreSQL
-- BobsBookstore - Microsoft SQL Server to PostgreSQL Migration
-- Converted: Step 2 of Migration Plan using DMS MCP Tool
-- =========================================================================
-- This file contains all SQL statements converted to PostgreSQL syntax
-- using the AWS DMS MCP Statement Conversion Tool
-- =========================================================================

-- -------------------------------------------------------------------------
-- STATEMENT 1: Simple SELECT from Author table
-- -------------------------------------------------------------------------
-- Original Statement: SELECT * FROM Author
-- Source File: AuthorsController.cs, Line 175, Method: FindAllAuthorsEmbeddedSql()
-- Conversion Method: DMS_TOOL
-- Conversion Status: SUCCESS
-- DMS Tool Output: Status=success, converted_sql_count=1
-- Schema Change: Author -> bobsusedbookstore_dbo.author (lowercase)
-- -------------------------------------------------------------------------
SELECT
    *
    FROM bobsusedbookstore_dbo.author;
-- -------------------------------------------------------------------------


-- -------------------------------------------------------------------------
-- STATEMENT 2: Stored Procedure Call - uspUpdateAuthorPersonalInfo
-- -------------------------------------------------------------------------
-- Original Statement (Full): DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Original Statement (EXEC part only): EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- Source File: AuthorsController.cs, Line 160, Method: EditUsingStoredProcedure()
-- Conversion Method: DMS_TOOL (EXEC part only - DECLARE/SELECT pattern requires manual handling)
-- Conversion Status: SUCCESS for EXEC part
-- DMS Tool Output (Full Statement): Status=error, Message='Statement definition is not valid.'
-- DMS Tool Output (EXEC only): Status=success, converted_sql_count=1
-- Schema Change: [dbo].[uspUpdateAuthorPersonalInfo] -> bobsusedbookstore_dbo.uspupdateauthorpersonalinfo (lowercase)
-- Procedure Name Change: uspUpdateAuthorPersonalInfo -> uspupdateauthorpersonalinfo
-- PostgreSQL Syntax: EXEC -> CALL
-- Note: Return value handling (DECLARE @rowsAffected INT; SELECT @rowsAffected) needs separate handling in application code
-- -------------------------------------------------------------------------
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
-- -------------------------------------------------------------------------


-- -------------------------------------------------------------------------
-- STATEMENT 3: Stored Procedure Call - uspDeleteAuthor
-- -------------------------------------------------------------------------
-- Original Statement (Full): DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Original Statement (EXEC part only): EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
-- Source File: AuthorsController.cs, Line 198, Method: DeleteAuthorEmbeddedSql()
-- Conversion Method: DMS_TOOL (EXEC part only - DECLARE/SELECT pattern requires manual handling)
-- Conversion Status: SUCCESS for EXEC part
-- DMS Tool Output: Status=success, converted_sql_count=1
-- Schema Change: [dbo].[uspDeleteAuthor] -> bobsusedbookstore_dbo.uspdeleteauthor (lowercase)
-- Procedure Name Change: uspDeleteAuthor -> uspdeleteauthor
-- PostgreSQL Syntax: EXEC -> CALL
-- Note: Return value handling (DECLARE @rowsAffected INT; SELECT @rowsAffected) needs separate handling in application code
-- -------------------------------------------------------------------------
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
-- -------------------------------------------------------------------------


-- -------------------------------------------------------------------------
-- STATEMENT 4: Complex Query with T-SQL Functions
-- -------------------------------------------------------------------------
-- Original Statement: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate
-- Source File: AuthorsController.cs, Line 215, Method: SelectAuthorsByHireYear()
-- Conversion Method: DMS_TOOL (using GenAI)
-- Conversion Status: SUCCESS
-- DMS Tool Output: Status=success, converted_sql_count=1
-- DMS Info: [7744 - Severity INFO - This conversion uses machine learning models]
-- Schema Change: Author -> bobsusedbookstore_dbo.author (lowercase)
-- Column Name Changes: All columns lowercase (BusinessEntityID -> businessentityid, etc.)
-- T-SQL Function Conversions:
--   FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') -> to_char(modifieddate, 'yyyy-MM-dd HH:mm:ss')
--   DATEDIFF(YEAR, BirthDate, GETDATE()) -> aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP)
--   DATEPART(YEAR, HireDate) -> date_part('year', hiredate)
--   GETDATE() -> clock_timestamp()
-- Parameter: @HireDate -> HireDate (parameter syntax may need adjustment in code)
-- -------------------------------------------------------------------------

/* [7744 - Severity INFO - This conversion uses machine learning models that generate predictions based on patterns in data. Output generated by a machine learning model is probabilistic and should be evaluated for accuracy as appropriate for your use case, including by employing human review of such output.] */
/* vvv ---- Beginning of statement generated using GenAI. ---- vvv */
SELECT businessentityid,
        to_char(modifieddate, 'yyyy-MM-dd HH:mm:ss') AS formattedmodifieddate,
        aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age
    FROM bobsusedbookstore_dbo.author
    WHERE date_part('year', hiredate) = @HireDate
/* ^^^ ---- End of statement generated using GenAI. ---- ^^^ */;
-- -------------------------------------------------------------------------


-- =========================================================================
-- CONVERSION SUMMARY
-- =========================================================================
-- Total Statements Processed: 4
-- Successfully Converted by DMS: 4 (with notes on Statement 2 and 3)
-- Failed Conversions Requiring Manual Intervention: 0
-- 
-- Key Schema Changes:
--   - Schema: dbo -> bobsusedbookstore_dbo
--   - Table names: Capitalized -> lowercase (Author -> author)
--   - Column names: PascalCase -> lowercase (BusinessEntityID -> businessentityid)
--   - Stored procedures: [dbo].[uspName] -> bobsusedbookstore_dbo.uspname (lowercase)
--
-- Key Syntax Changes:
--   - EXEC stored_proc -> CALL stored_proc
--   - FORMAT() -> to_char()
--   - DATEDIFF() -> aws_sqlserver_ext.datediff()
--   - DATEPART() -> date_part()
--   - GETDATE() -> clock_timestamp()
--
-- Notes:
--   1. Statement 2 and 3: The full DECLARE/EXEC/SELECT pattern did not convert through DMS
--      The EXEC part alone converted successfully using DMS tool
--      Return value handling needs to be addressed in application code
--
--   2. Statement 4: Uses GenAI conversion from DMS, output should be validated
--      Requires aws_sqlserver_ext extension for datediff function
--
--   3. All parameter names preserve @ symbol from original
--      May need adjustment based on how Npgsql handles parameters
--
-- Next Steps:
--   - Validate SQL equivalency for all statement pairs
--   - Re-integrate converted statements into source code
--   - Update parameter handling for PostgreSQL in application code
--   - Test stored procedure calls and return value handling
-- =========================================================================
