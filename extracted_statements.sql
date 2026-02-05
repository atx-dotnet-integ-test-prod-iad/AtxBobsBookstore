-- ============================================================================
-- SQL Statement Extraction Catalog
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2026-02-04
-- ============================================================================

-- ============================================================================
-- STATEMENT 1
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 162
-- Method: EditUsingStoredProcedure
-- Statement Type: Stored Procedure Call with DECLARE and return value
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- SQL Server Specific Syntax: DECLARE, EXEC, [dbo], @variable assignment
-- Original SQL Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 230
-- Method: SelectAuthorsByHireYear
-- Statement Type: Embedded SELECT Query with SQL Server Functions
-- Parameters: @HireDate (int - year)
-- SQL Server Specific Syntax: FORMAT(), DATEDIFF(), GETDATE(), DATEPART(), [dbo] schema reference
-- Original SQL Statement:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 3
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 213
-- Method: DeleteAuthorEmbeddedSql
-- Statement Type: Stored Procedure Call with DECLARE and return value
-- Parameters: @BusinessEntityID (int)
-- SQL Server Specific Syntax: DECLARE, EXEC, [dbo], @variable assignment
-- Original SQL Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4
-- ============================================================================
-- Source File: AuthorsController.cs
-- Line Number: 189
-- Method: FindAllAuthorsEmbeddedSql
-- Statement Type: Simple SELECT Query
-- Parameters: None
-- SQL Server Specific Syntax: None (PostgreSQL compatible, but may need schema verification)
-- Original SQL Statement:
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 5
-- ============================================================================
-- Source File: ProductsController.cs
-- Line Number: 31
-- Method: FindAllProducts
-- Statement Type: Stored Procedure Call
-- Parameters: None
-- SQL Server Specific Syntax: EXEC, [dbo]
-- Original SQL Statement:
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total SQL Statements Extracted: 5
-- Statements with Stored Procedures: 3 (Statements 1, 3, 5)
-- Statements with SQL Server Functions: 1 (Statement 2)
-- Simple SELECT Statements: 1 (Statement 4)
-- 
-- SQL Server Specific Features Found:
-- - DECLARE statements for variable assignment
-- - EXEC statements for stored procedure calls
-- - [dbo] schema qualifiers
-- - FORMAT() function for date formatting
-- - DATEDIFF() function for date arithmetic
-- - GETDATE() function for current date/time
-- - DATEPART() function for extracting date parts
-- 
-- Files Containing SQL Statements:
-- 1. AuthorsController.cs (4 statements)
-- 2. ProductsController.cs (1 statement)
-- ============================================================================
