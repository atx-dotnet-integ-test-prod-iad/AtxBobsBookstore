-- ================================================================================================
-- EXTRACTED SQL STATEMENTS FOR MIGRATION FROM SQL SERVER TO POSTGRESQL
-- Bob's Bookstore Application
-- Migration Date: 2026-01-18
-- ================================================================================================

-- ================================================================================================
-- STATEMENT 1: Edit Author Using Stored Procedure
-- ================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~154
-- Description: Updates author personal information using a stored procedure with return value
-- Pattern Type: DECLARE/EXEC with return value assignment and SELECT
-- SQL Server Specific: DECLARE statement, EXEC with return value assignment, [dbo].[procedure] syntax
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), 
--             @MaritalStatus (string), @Gender (string)

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ================================================================================================
-- STATEMENT 2: Find All Authors
-- ================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~178
-- Description: Retrieves all authors from the database
-- Pattern Type: Simple SELECT statement
-- SQL Server Specific: None (but schema may be updated by DMS)
-- Parameters: None

SELECT * FROM bobsbookstore_dbo.author;

-- ================================================================================================
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~197
-- Description: Deletes an author using a stored procedure with return value
-- Pattern Type: DECLARE/EXEC with return value assignment and SELECT
-- SQL Server Specific: DECLARE statement, EXEC with return value assignment, [dbo].[procedure] syntax
-- Parameters: @BusinessEntityID (int)

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ================================================================================================
-- STATEMENT 4: Select Authors By Hire Year with Age Calculation
-- ================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~217
-- Description: Retrieves authors hired in a specific year with formatted modified date and age
-- Pattern Type: Complex SELECT with T-SQL specific date/time functions
-- SQL Server Specific: FORMAT(), DATEDIFF(), DATEPART(), GETDATE()
-- Parameters: @HireDate (int - year value)
-- Critical Functions:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss'): Formats date to string
--   - DATEDIFF(YEAR, BirthDate, GETDATE()): Calculates age in years
--   - DATEPART(YEAR, HireDate): Extracts year from HireDate
--   - GETDATE(): Returns current date/time

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ================================================================================================
-- STATEMENT 5: Find All Products Using Stored Procedure
-- ================================================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~30
-- Description: Retrieves all products using a stored procedure
-- Pattern Type: Simple EXEC stored procedure call
-- SQL Server Specific: EXEC statement, [dbo].[procedure] syntax
-- Parameters: None

EXEC [dbo].[uspGetProductData];

-- ================================================================================================
-- SUMMARY OF SQL STATEMENTS IDENTIFIED
-- ================================================================================================
-- Total Statements: 5
-- Statements with Stored Procedures: 3 (Statement 1, 3, 5)
-- Statements with T-SQL Functions: 1 (Statement 4)
-- Simple SELECT Statements: 1 (Statement 2)
-- 
-- SQL Server Specific Syntax to be Converted:
-- 1. DECLARE variable declarations
-- 2. EXEC with return value assignment pattern
-- 3. [dbo].[object_name] schema qualification syntax
-- 4. FORMAT() function (T-SQL specific)
-- 5. DATEDIFF() function (T-SQL specific)
-- 6. DATEPART() function (T-SQL specific)
-- 7. GETDATE() function (T-SQL specific)
-- 
-- PostgreSQL Conversion Requirements:
-- 1. DECLARE/EXEC pattern → PostgreSQL function call: SELECT function_name(params)
-- 2. [dbo].[object] → schema.object (likely bobsbookstore_dbo.object)
-- 3. FORMAT(date, pattern) → TO_CHAR(date, pattern) with PostgreSQL format codes
-- 4. DATEDIFF(YEAR, date1, date2) → EXTRACT(YEAR FROM AGE(date2, date1))
-- 5. DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
-- 6. GETDATE() → CURRENT_TIMESTAMP or NOW()
-- 
-- All statements above MUST be processed through DMS MCP tool for conversion.
-- ================================================================================================
