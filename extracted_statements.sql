-- Extracted SQL Statements from BobsBookstore Application
-- Date: Migration from MS SQL Server to PostgreSQL
-- This file contains all SQL statements identified in the codebase for conversion

-- ============================================================================
-- Statement 1: Simple SELECT from author table
-- Source: AuthorsController.cs, FindAllAuthorsEmbeddedSql method (line ~188)
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- Statement 2: Stored Procedure Call - Update Author Personal Info
-- Source: AuthorsController.cs, EditUsingStoredProcedure method (line ~158)
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- Statement 3: Stored Procedure Call - Delete Author
-- Source: AuthorsController.cs, DeleteAuthorEmbeddedSql method (line ~206)
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- Statement 4: Complex SELECT with SQL Server Functions
-- Source: AuthorsController.cs, SelectAuthorsByHireYear method (line ~225)
-- Uses: FORMAT, DATEDIFF, GETDATE, DATEPART functions
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- Statement 5: Stored Procedure Execution - Get Product Data
-- Source: ProductsController.cs, FindAllProducts method (line ~31)
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Total Statements: 5
-- Simple SELECT: 1
-- Stored Procedure Calls: 3
-- Complex SELECT with Functions: 1
-- 
-- SQL Server Specific Functions Used:
-- - FORMAT: Converts datetime to formatted string
-- - DATEDIFF: Calculates date difference
-- - GETDATE: Returns current date/time
-- - DATEPART: Extracts part of date
-- - DECLARE: Variable declaration
-- - EXEC: Execute stored procedure
--
-- Schema References:
-- - bobsbookstore_dbo.author (appears in statements 1 and 4)
-- - [dbo].[uspUpdateAuthorPersonalInfo] (stored procedure)
-- - [dbo].[uspDeleteAuthor] (stored procedure)
-- - [dbo].[uspGetProductData] (stored procedure)
-- ============================================================================
