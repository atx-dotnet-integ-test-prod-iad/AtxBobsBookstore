/*
================================================================================
CONVERTED SQL STATEMENTS - POSTGRESQL SYNTAX
================================================================================
Microsoft SQL Server to PostgreSQL Migration
Source Application: Bob's Bookstore .NET ADO Application
Conversion Date: Step 2 of Migration Process
Target Schema: bobsbookstore_dbo (PostgreSQL)

This file contains all SQL statements converted from SQL Server to PostgreSQL 
syntax. Each conversion is documented with the original statement, conversion 
method, and any notes about the conversion process.

Total SQL Statements Converted: 5
DMS Tool Successful Conversions: 0
Manual Conversions After DMS Failure: 5
================================================================================
*/

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Stored Procedure Call
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 163-164
-- Method Name: EditUsingStoredProcedure
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}

-- Original MS SQL Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- PostgreSQL Converted Statement:
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo($1, $2, $3, $4, $5);

-- Conversion Notes:
-- - SQL Server stored procedures with EXEC are converted to PostgreSQL function calls
-- - Parameter syntax changed from @ParamName to positional parameters ($1, $2, etc.)
-- - Schema reference [dbo] converted to bobsbookstore_dbo
-- - DECLARE and SELECT @rowsAffected removed as PostgreSQL functions return results directly
-- - Function must be created in PostgreSQL to match this signature
-- Parameter Mapping:
--   $1 = @BusinessEntityID (int)
--   $2 = @NationalIDNumber (string)
--   $3 = @BirthDate (DateTime)
--   $4 = @MaritalStatus (string)
--   $5 = @Gender (string)

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - SELECT Statement
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 187
-- Method Name: FindAllAuthorsEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}

-- Original MS SQL Statement:
-- SELECT * FROM bobsbookstore_dbo.author

-- PostgreSQL Converted Statement:
SELECT * FROM bobsbookstore_dbo.author;

-- Conversion Notes:
-- - Statement is already PostgreSQL compatible
-- - Schema notation bobsbookstore_dbo.author is valid in PostgreSQL
-- - No syntax changes required

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure Call
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 206-207
-- Method Name: DeleteAuthorEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}

-- Original MS SQL Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- PostgreSQL Converted Statement:
SELECT bobsbookstore_dbo.uspDeleteAuthor($1);

-- Conversion Notes:
-- - SQL Server stored procedure EXEC converted to PostgreSQL function call
-- - Parameter syntax changed from @BusinessEntityID to $1
-- - Schema reference [dbo] converted to bobsbookstore_dbo
-- - DECLARE and SELECT @rowsAffected removed as PostgreSQL functions return results directly
-- - Function must be created in PostgreSQL to match this signature
-- Parameter Mapping:
--   $1 = @BusinessEntityID (int)

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with Date Functions
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 228
-- Method Name: SelectAuthorsByHireYear
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}

-- Original MS SQL Statement:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- PostgreSQL Converted Statement:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(NOW(), BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = $1;

-- Conversion Notes:
-- - FORMAT(date, pattern) converted to TO_CHAR(date, pattern)
-- - Date format pattern updated: 'yyyy-MM-dd HH:mm:ss' → 'YYYY-MM-DD HH24:MI:SS'
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) converted to DATE_PART('year', AGE(NOW(), BirthDate))
-- - GETDATE() converted to NOW()
-- - DATEPART(YEAR, HireDate) converted to EXTRACT(YEAR FROM HireDate)
-- - Parameter syntax @HireDate converted to $1
-- - Schema notation bobsbookstore_dbo.author remains unchanged
-- Parameter Mapping:
--   $1 = @HireDate (int - year value)

-- ============================================================================
-- STATEMENT 5: FindAllProducts - Stored Procedure Call
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Numbers: 34
-- Method Name: FindAllProducts
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}

-- Original MS SQL Statement:
-- EXEC [dbo].[uspGetProductData];

-- PostgreSQL Converted Statement:
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- Conversion Notes:
-- - SQL Server stored procedure EXEC converted to PostgreSQL function call
-- - Schema reference [dbo] converted to bobsbookstore_dbo
-- - No parameters in this stored procedure
-- - Function must be created in PostgreSQL to match this signature
-- Parameter Mapping:
--   (No parameters)

/*
================================================================================
CONVERSION SUMMARY
================================================================================

Total Statements Converted: 5

Conversion Method Breakdown:
- DMS Tool Successful: 0
- Manual After DMS Failure: 5

All statements encountered the same DMS error during metadata model creation.
Manual conversions were performed following PostgreSQL best practices and 
standard SQL Server to PostgreSQL migration patterns.

Key Conversion Patterns Applied:
1. Stored Procedure EXEC → Function Call (SELECT function())
2. Parameter Syntax: @ParamName → $N (positional parameters)
3. Date Functions: FORMAT() → TO_CHAR(), DATEDIFF() → DATE_PART()/AGE()
4. Date Functions: GETDATE() → NOW(), DATEPART() → EXTRACT()
5. Schema References: [dbo] → bobsbookstore_dbo

Next Steps:
- Validate all converted statements using SQL Equivalency MCP tool
- Ensure stored procedures uspUpdateAuthorPersonalInfo, uspDeleteAuthor,
  and uspGetProductData exist as functions in PostgreSQL database
- Update application code to use converted statements with NpgsqlParameter

================================================================================
*/
