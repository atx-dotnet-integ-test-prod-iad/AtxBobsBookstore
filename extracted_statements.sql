-- =========================================================================
-- SQL STATEMENT EXTRACTION CATALOG
-- BobsBookstore - Microsoft SQL Server to PostgreSQL Migration
-- Extracted: Step 1 of Migration Plan
-- =========================================================================
-- This file contains ALL SQL statements extracted from the codebase
-- that must be processed through the DMS MCP tool for PostgreSQL conversion.
-- =========================================================================

-- -------------------------------------------------------------------------
-- STATEMENT 1: Simple SELECT from Author table
-- -------------------------------------------------------------------------
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 175
-- Method: FindAllAuthorsEmbeddedSql()
-- Statement Type: Inline SQL - SELECT query
-- Parameters: None
-- Context: Retrieves all authors from the Author table
-- -------------------------------------------------------------------------
SELECT * FROM Author
-- -------------------------------------------------------------------------


-- -------------------------------------------------------------------------
-- STATEMENT 2: Stored Procedure Call - uspUpdateAuthorPersonalInfo
-- -------------------------------------------------------------------------
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 160
-- Method: EditUsingStoredProcedure()
-- Statement Type: Stored Procedure Execution with Return Value
-- Parameters: 
--   @BusinessEntityID (int)
--   @NationalIDNumber (string)
--   @BirthDate (DateTime - converted to UTC)
--   @MaritalStatus (string)
--   @Gender (string)
-- Context: Updates author personal information and returns rows affected
-- -------------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- -------------------------------------------------------------------------


-- -------------------------------------------------------------------------
-- STATEMENT 3: Stored Procedure Call - uspDeleteAuthor
-- -------------------------------------------------------------------------
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 198
-- Method: DeleteAuthorEmbeddedSql()
-- Statement Type: Stored Procedure Execution with Return Value
-- Parameters: 
--   @BusinessEntityID (int)
-- Context: Deletes an author and returns rows affected
-- -------------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- -------------------------------------------------------------------------


-- -------------------------------------------------------------------------
-- STATEMENT 4: Complex Query with T-SQL Functions
-- -------------------------------------------------------------------------
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 215
-- Method: SelectAuthorsByHireYear()
-- Statement Type: Inline SQL - SELECT with T-SQL specific functions
-- Parameters: 
--   @HireDate (int - hire year)
-- T-SQL Functions Used:
--   FORMAT() - Date formatting function
--   DATEDIFF() - Date difference calculation
--   GETDATE() - Current date/time
--   DATEPART() - Extract date part
-- Context: Selects authors hired in a specific year with formatted dates and calculated age
-- -------------------------------------------------------------------------
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- -------------------------------------------------------------------------


-- =========================================================================
-- SUMMARY
-- =========================================================================
-- Total SQL Statements Extracted: 4
-- 
-- Breakdown by Type:
--   - Simple SELECT queries: 1
--   - Stored procedure calls: 2
--   - Complex queries with T-SQL functions: 1
--
-- Files Containing SQL Statements:
--   - AuthorsController.cs: 4 statements
--   - ServicesSetup.cs: 0 statements (connection string only, no SQL)
--   - ApplicationDbContext.cs: 0 statements (Entity Framework config only)
--   - Repository classes: 0 statements (using Entity Framework)
--
-- T-SQL Specific Syntax Requiring Conversion:
--   - EXEC stored procedure syntax
--   - DECLARE variable syntax
--   - FORMAT() function
--   - DATEDIFF() function
--   - GETDATE() function
--   - DATEPART() function
--   - Schema qualified names: [dbo].[procedureName]
--   - Parameter syntax: @paramName
--
-- Schema Information:
--   - Current SQL Server schema: dbo
--   - Target PostgreSQL schema: bobsbookstore_dbo (from ApplicationDbContext.cs)
--   - Table name mapping: Author -> bobsbookstore_dbo.author (lowercase)
--
-- Next Steps:
--   - Process each statement through DMS MCP tool
--   - Document any schema object name changes
--   - Create converted_statements.sql with PostgreSQL versions
-- =========================================================================
