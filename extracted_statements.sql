-- ============================================================================
-- SQL Statement Extraction Catalog
-- Generated: Step 1 of SQL Server to PostgreSQL Migration
-- Purpose: Comprehensive catalog of all SQL statements requiring conversion
-- ============================================================================

-- ============================================================================
-- Statement ID: 1
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: EditUsingStoredProcedure
-- Statement Type: Stored Procedure Call with DECLARE/EXEC Pattern
-- SQL Server Specific Elements: 
--   - DECLARE @variable syntax
--   - EXEC with return value assignment
--   - [dbo] schema notation
--   - Stored procedure uspUpdateAuthorPersonalInfo
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int)
-- @NationalIDNumber (string)
-- @BirthDate (DateTime)
-- @MaritalStatus (string)
-- @Gender (string)


-- ============================================================================
-- Statement ID: 2
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: DeleteAuthorEmbeddedSql
-- Statement Type: Stored Procedure Call with DECLARE/EXEC Pattern
-- SQL Server Specific Elements:
--   - DECLARE @variable syntax
--   - EXEC with return value assignment
--   - [dbo] schema notation
--   - Stored procedure uspDeleteAuthor
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int)


-- ============================================================================
-- Statement ID: 3
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: FindAllAuthorsEmbeddedSql
-- Statement Type: Inline SQL - Simple SELECT
-- SQL Server Specific Elements:
--   - Schema notation bobsbookstore_dbo (may be converted by DMS)
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- Parameters: None


-- ============================================================================
-- Statement ID: 4
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: SelectAuthorsByHireYear
-- Statement Type: Inline SQL - Complex SELECT with SQL Server Functions
-- SQL Server Specific Elements:
--   - FORMAT() function - SQL Server specific date formatting
--   - DATEDIFF(YEAR, ...) - SQL Server date calculation
--   - DATEPART(YEAR, ...) - SQL Server date part extraction
--   - GETDATE() - SQL Server current date/time function
--   - Schema notation bobsbookstore_dbo
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Parameters:
-- @HireDate (int) - Year value


-- ============================================================================
-- Statement ID: 5
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method Name: FindAllProducts
-- Statement Type: Stored Procedure Call
-- SQL Server Specific Elements:
--   - EXEC syntax
--   - [dbo] schema notation
--   - Stored procedure uspGetProductData
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- Parameters: None


-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total Statements Extracted: 5
-- Stored Procedure Calls: 3 (statements 1, 2, 5)
-- Inline SQL Statements: 2 (statements 3, 4)
-- Statements with Complex Functions: 1 (statement 4)
-- Statements with Parameters: 3 (statements 1, 2, 4)
-- 
-- Next Step: Convert all statements using DMS MCP tool
-- ============================================================================
