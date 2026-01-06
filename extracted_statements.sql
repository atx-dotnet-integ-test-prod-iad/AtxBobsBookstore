-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Migration: Microsoft SQL Server to PostgreSQL
-- Project: BobsBookstore
-- Date: 2026-01-06
-- ============================================================================
-- This file contains all SQL statements extracted from the application code
-- that need to be converted from T-SQL to PostgreSQL syntax.
-- Each statement is numbered for tracking through the conversion and validation process.
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Information
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~158
-- Type: EXEC (Stored Procedure Call)
-- Description: Calls stored procedure to update author personal information with return value
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (datetime), @MaritalStatus (string), @Gender (string)
-- Complexity: HARD (stored procedure with multiple parameters and return value)
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~185
-- Type: SELECT
-- Description: Simple select statement to retrieve all authors from the author table
-- Parameters: None
-- Complexity: EASY (simple SELECT with no joins or complex functions)
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~205
-- Type: EXEC (Stored Procedure Call)
-- Description: Calls stored procedure to delete author with return value
-- Parameters: @BusinessEntityID (int)
-- Complexity: HARD (stored procedure with parameter and return value)
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Select Authors with Date Functions
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~226
-- Type: SELECT
-- Description: Complex select statement using SQL Server date functions (FORMAT, DATEDIFF, DATEPART, GETDATE)
-- Parameters: @HireDate (int - year value)
-- Complexity: MEDIUM (uses SQL Server specific date functions)
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: FindAllProducts - Get All Products via Stored Procedure
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~30
-- Type: EXEC (Stored Procedure Call)
-- Description: Calls stored procedure to retrieve all product data
-- Parameters: None
-- Complexity: HARD (stored procedure call)
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Total Statements: 5
-- Simple SELECT: 1 (Statement 2)
-- Complex SELECT with Functions: 1 (Statement 4)
-- Stored Procedure Calls: 3 (Statements 1, 3, 5)
-- ============================================================================
-- SCHEMA INFORMATION
-- ============================================================================
-- Schema: bobsbookstore_dbo
-- Tables Referenced:
--   - author (businessentityid, nationalidnumber, loginid, jobtitle, birthdate, maritalstatus, gender, hiredate, vacationhours, modifieddate)
--   - product (productid, name, productnumber, safetystocklevel)
-- Stored Procedures Referenced:
--   - [dbo].[uspUpdateAuthorPersonalInfo]
--   - [dbo].[uspDeleteAuthor]
--   - [dbo].[uspGetProductData]
-- ============================================================================
