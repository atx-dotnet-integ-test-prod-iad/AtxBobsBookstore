-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration for Bob's Bookstore
-- ============================================================================
-- Purpose: Comprehensive catalog of ALL SQL statements extracted from the
--          codebase for DMS conversion processing
-- Date: 2026-01-29
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Edit Author Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~165
-- Type: Stored Procedure Call with Output Parameter
-- Construction Method: Inline SQL string with DECLARE and EXEC
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- Description: Updates author personal information using stored procedure uspUpdateAuthorPersonalInfo
-- 
-- Original SQL Statement:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: Find All Authors
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~188
-- Type: Simple SELECT Statement
-- Construction Method: Inline SQL string
-- Parameters: None
-- Description: Retrieves all authors from the author table
-- 
-- Original SQL Statement:
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~210
-- Type: Stored Procedure Call with Output Parameter
-- Construction Method: Inline SQL string with DECLARE and EXEC
-- Parameters: @BusinessEntityID
-- Description: Deletes an author using stored procedure uspDeleteAuthor
-- 
-- Original SQL Statement:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Date Functions
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~232
-- Type: Complex SELECT with T-SQL Date Functions
-- Construction Method: Inline SQL string
-- Parameters: @HireDate
-- Description: Retrieves authors hired in a specific year with formatted date and calculated age
-- T-SQL Functions Used: FORMAT, DATEDIFF, DATEPART, GETDATE
-- 
-- Original SQL Statement:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: Get Product Data Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~32
-- Type: Stored Procedure Call
-- Construction Method: Inline SQL string with EXEC
-- Parameters: None
-- Description: Retrieves all product data using stored procedure uspGetProductData
-- 
-- Original SQL Statement:
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Total Statements Extracted: 5
-- 
-- By Type:
-- - Stored Procedure Calls: 3 (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
-- - Simple SELECT: 1 (Find All Authors)
-- - Complex SELECT with Functions: 1 (Select Authors by Hire Year)
-- 
-- By Source File:
-- - AuthorsController.cs: 4 statements
-- - ProductsController.cs: 1 statement
-- 
-- T-SQL Functions Requiring Conversion:
-- - FORMAT: Date formatting (Statement 4)
-- - DATEDIFF: Date difference calculation (Statement 4)
-- - DATEPART: Date part extraction (Statement 4)
-- - GETDATE: Current date/time (Statement 4)
-- 
-- Stored Procedures Requiring Conversion:
-- - [dbo].[uspUpdateAuthorPersonalInfo]: Update author personal info with 5 parameters
-- - [dbo].[uspDeleteAuthor]: Delete author with 1 parameter
-- - [dbo].[uspGetProductData]: Retrieve all product data with no parameters
-- 
-- ============================================================================
-- END OF EXTRACTED STATEMENTS CATALOG
-- ============================================================================
