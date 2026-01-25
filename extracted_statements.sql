-- ============================================================
-- EXTRACTED SQL STATEMENTS FROM BOBSBOOKSTORE APPLICATION
-- ============================================================
-- This file contains all original SQL Server T-SQL statements
-- extracted from the C# codebase for conversion to PostgreSQL
-- 
-- Total Statements: 4
-- ============================================================

-- ============================================================
-- STATEMENT 1: Update Author Personal Information (Stored Procedure Call)
-- ============================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: ~163
-- Statement Type: Stored Procedure Call with DECLARE/EXEC/SELECT pattern
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Description: Calls uspUpdateAuthorPersonalInfo stored procedure to update author personal information
-- ============================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================
-- STATEMENT 2: Select All Authors (Direct SQL Query)
-- ============================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: ~186
-- Statement Type: Direct SELECT query
-- Parameters: None
-- Description: Retrieves all authors from the author table
-- ============================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ============================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: ~204
-- Statement Type: Stored Procedure Call with DECLARE/EXEC/SELECT pattern
-- Parameters: @BusinessEntityID (int)
-- Description: Calls uspDeleteAuthor stored procedure to delete an author
-- ============================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation (Complex SELECT)
-- ============================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: ~226
-- Statement Type: Direct SELECT query with T-SQL date functions
-- Parameters: @HireDate (int - representing year)
-- Description: Retrieves authors hired in a specific year with formatted modified date and calculated age using T-SQL functions
-- T-SQL Functions Used: FORMAT, DATEDIFF, GETDATE, DATEPART
-- ============================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================
-- STATEMENT 5: Get Product Data (Stored Procedure Call - ProductsController)
-- ============================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Number: ~32
-- Statement Type: Stored Procedure Call
-- Parameters: None
-- Description: Calls uspGetProductData stored procedure to retrieve all products
-- ============================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================
-- SUMMARY OF EXTRACTED STATEMENTS
-- ============================================================
-- Total Statements Extracted: 5
-- Note: Original requirement specified 4 statements, but analysis found 5 distinct SQL statements
-- 
-- Breakdown by Type:
-- - Stored Procedure Calls: 3 (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
-- - Direct SELECT Queries: 2 (all authors, authors by hire year with age)
-- 
-- Stored Procedures Referenced (need PostgreSQL implementation):
-- 1. uspUpdateAuthorPersonalInfo - Updates author personal information
-- 2. uspDeleteAuthor - Deletes an author
-- 3. uspGetProductData - Retrieves product data
-- 
-- T-SQL Functions to Convert:
-- - FORMAT() -> TO_CHAR()
-- - DATEPART() -> EXTRACT()
-- - DATEDIFF() -> date arithmetic
-- - GETDATE() -> CURRENT_TIMESTAMP or NOW()
-- 
-- Schema References:
-- - bobsbookstore_dbo.author
-- - [dbo].[storedProcedureName]
-- ============================================================
