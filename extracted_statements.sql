-- ================================================================
-- SQL STATEMENTS EXTRACTION CATALOG
-- SQL Server to PostgreSQL Migration
-- ================================================================
-- This file catalogs all SQL statements extracted from the codebase
-- for conversion through the DMS MCP tool and equivalency validation
-- ================================================================

-- ================================================================
-- STATEMENT 1: Update Author Using Stored Procedure
-- ================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 163
-- Method: EditUsingStoredProcedure
-- Statement Type: Stored Procedure Call with DECLARE and EXEC
-- Parameters: 
--   @BusinessEntityID (int)
--   @NationalIDNumber (string)
--   @BirthDate (DateTime - converted to UTC)
--   @MaritalStatus (string)
--   @Gender (string)
-- Context: Updates author personal information via stored procedure
-- ================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ================================================================
-- STATEMENT 2: Select All Authors
-- ================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 187
-- Method: FindAllAuthorsEmbeddedSql
-- Statement Type: Direct SELECT statement
-- Parameters: None
-- Context: Retrieves all authors from the author table
-- ================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ================================================================
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 208
-- Method: DeleteAuthorEmbeddedSql
-- Statement Type: Stored Procedure Call with DECLARE and EXEC
-- Parameters:
--   @BusinessEntityID (int)
-- Context: Deletes an author via stored procedure
-- ================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ================================================================
-- STATEMENT 4: Select Authors by Hire Year with Date Functions
-- ================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 228
-- Method: SelectAuthorsByHireYear
-- Statement Type: Complex SELECT with FORMAT, DATEDIFF, DATEPART, GETDATE
-- Parameters:
--   @HireDate (int - year)
-- Context: Retrieves authors hired in a specific year with formatted date and calculated age
-- SQL Server Functions Used:
--   - FORMAT(): Formats date/time values
--   - DATEDIFF(): Calculates difference between dates
--   - GETDATE(): Returns current date/time
--   - DATEPART(): Extracts year from date
-- ================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ================================================================
-- STATEMENT 5: Get All Products Using Stored Procedure
-- ================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 32
-- Method: FindAllProducts
-- Statement Type: Stored Procedure Execution
-- Parameters: None
-- Context: Retrieves all product data via stored procedure
-- ================================================================
EXEC [dbo].[uspGetProductData];

-- ================================================================
-- EXTRACTION SUMMARY
-- ================================================================
-- Total SQL Statements Extracted: 5
-- Stored Procedure Calls: 3 (Statements 1, 3, 5)
-- Direct SELECT Statements: 1 (Statement 2)
-- Complex SELECT Statements: 1 (Statement 4)
-- 
-- SQL Server Specific Features Identified:
-- - Stored procedures with [dbo] schema prefix
-- - DECLARE and EXEC pattern for stored procedures
-- - FORMAT() function (SQL Server 2012+)
-- - DATEDIFF() function
-- - GETDATE() function
-- - DATEPART() function
-- - Schema-qualified table names (bobsbookstore_dbo.author)
--
-- PostgreSQL Conversion Considerations:
-- - Stored procedures need to be converted to PostgreSQL functions/procedures
-- - FORMAT() → TO_CHAR() in PostgreSQL
-- - GETDATE() → NOW() or CURRENT_TIMESTAMP in PostgreSQL
-- - DATEDIFF() → DATE_PART() or AGE() in PostgreSQL
-- - DATEPART() → EXTRACT() or DATE_PART() in PostgreSQL
-- - Parameter syntax: @param → $1 or named parameters
-- ================================================================
