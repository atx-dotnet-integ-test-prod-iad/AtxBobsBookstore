/*
================================================================================
EXTRACTED SQL STATEMENTS CATALOG
================================================================================
Microsoft SQL Server to PostgreSQL Migration
Source Application: Bob's Bookstore .NET ADO Application
Extraction Date: Step 1 of Migration Process
Target Schema: bobsbookstore_dbo (PostgreSQL)

This catalog contains all SQL statements extracted from the codebase for 
conversion to PostgreSQL syntax. Each statement is documented with metadata
including source location, method name, statement type, and parameter usage.

Total SQL Statements Extracted: 5
================================================================================
*/

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Stored Procedure Call
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 163-164
-- Method Name: EditUsingStoredProcedure
-- Statement Type: STORED_PROCEDURE
-- Uses Parameters: YES (5 parameters)
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- String Concatenation: NO
-- StringBuilder Usage: NO
-- Description: Calls SQL Server stored procedure uspUpdateAuthorPersonalInfo to update author personal information
-- Original Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - SELECT Statement
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 187
-- Method Name: FindAllAuthorsEmbeddedSql
-- Statement Type: SELECT
-- Uses Parameters: NO
-- Parameters: None
-- String Concatenation: NO
-- StringBuilder Usage: NO
-- Description: Retrieves all authors from the bobsbookstore_dbo.author table
-- Original Statement:
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure Call
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 206-207
-- Method Name: DeleteAuthorEmbeddedSql
-- Statement Type: STORED_PROCEDURE
-- Uses Parameters: YES (1 parameter)
-- Parameters: @BusinessEntityID
-- String Concatenation: NO
-- StringBuilder Usage: NO
-- Description: Calls SQL Server stored procedure uspDeleteAuthor to delete an author by BusinessEntityID
-- Original Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with Date Functions
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 228
-- Method Name: SelectAuthorsByHireYear
-- Statement Type: SELECT
-- Uses Parameters: YES (1 parameter)
-- Parameters: @HireDate
-- String Concatenation: NO
-- StringBuilder Usage: NO
-- Description: Selects authors filtered by hire year with formatted date and age calculation using SQL Server date functions
-- SQL Server Functions Used: FORMAT(), DATEDIFF(), GETDATE(), DATEPART()
-- Original Statement:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: FindAllProducts - Stored Procedure Call
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Numbers: 34
-- Method Name: FindAllProducts
-- Statement Type: STORED_PROCEDURE
-- Uses Parameters: NO
-- Parameters: None
-- String Concatenation: NO
-- StringBuilder Usage: NO
-- Description: Calls SQL Server stored procedure uspGetProductData to retrieve all product data
-- Original Statement:
EXEC [dbo].[uspGetProductData];

/*
================================================================================
EXTRACTION SUMMARY
================================================================================

Total Statements Extracted: 5

Breakdown by Type:
- SELECT Statements: 2 (statements 2 and 4)
- STORED_PROCEDURE Calls: 3 (statements 1, 3, and 5)
- INSERT Statements: 0
- UPDATE Statements: 0
- DELETE Statements: 0

Parameterized Statements: 3 (statements 1, 3, and 4)
Non-Parameterized Statements: 2 (statements 2 and 5)

String Concatenation Used: 0
StringBuilder Usage: 0

SQL Server Specific Features Identified:
1. Stored Procedure Calls: [dbo].[uspUpdateAuthorPersonalInfo], [dbo].[uspDeleteAuthor], [dbo].[uspGetProductData]
2. Date Functions: FORMAT(), DATEDIFF(), GETDATE(), DATEPART()
3. Parameter Syntax: @ParameterName (SQL Server style)
4. Schema Qualification: [dbo]. (SQL Server bracket notation)
5. Variable Declaration: DECLARE @rowsAffected INT

Target Schema for PostgreSQL: bobsbookstore_dbo

Files Analyzed:
1. app/Bookstore.Web/Controllers/AuthorsController.cs
2. app/Bookstore.Web/Controllers/ProductsController.cs

Next Steps:
- Process each statement through DMS MCP tool for conversion
- Document any conversion failures or warnings
- Create converted_statements.sql with PostgreSQL equivalents
- Maintain mapping between original and converted statements

================================================================================
*/
