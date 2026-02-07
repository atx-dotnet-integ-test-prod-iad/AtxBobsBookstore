-- =============================================================================
-- SQL STATEMENT EXTRACTION CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Date: 2026-02-07
-- =============================================================================
-- This file contains all SQL statements extracted from the BobsBookstore application
-- Each statement is documented with its source file, method, line number context, and parameters
-- =============================================================================

-- =============================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- =============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~152
-- Description: Executes stored procedure uspUpdateAuthorPersonalInfo with return value capture
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Return: @rowsAffected (INT)
-- =============================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- =============================================================================
-- STATEMENT 2: Select All Authors (Simple SELECT)
-- =============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~172
-- Description: Retrieves all authors from the author table
-- Parameters: None
-- Return: List<Author>
-- =============================================================================

SELECT * FROM bobsbookstore_dbo.author

-- =============================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- =============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~189
-- Description: Executes stored procedure uspDeleteAuthor with return value capture
-- Parameters: @BusinessEntityID (int)
-- Return: @rowsAffected (INT)
-- =============================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- =============================================================================
-- STATEMENT 4: Select Authors By Hire Year with Complex Functions (Complex SELECT)
-- =============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~205
-- Description: Retrieves authors with formatted modified date and calculated age based on hire year
-- Uses T-SQL functions: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Parameters: @HireDate (int) - represents year
-- Return: List<AuthorAgeResult>
-- =============================================================================

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- =============================================================================
-- STATEMENT 5: Get All Products (Stored Procedure Call)
-- =============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~31
-- Description: Executes stored procedure uspGetProductData to retrieve all products
-- Parameters: None
-- Return: List<Product>
-- =============================================================================

EXEC [dbo].[uspGetProductData];

-- =============================================================================
-- END OF EXTRACTION CATALOG
-- Total Statements Extracted: 5
-- - Stored Procedure Calls: 3 (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
-- - Simple SELECT: 1 (SELECT * FROM author)
-- - Complex SELECT with T-SQL Functions: 1 (SELECT with FORMAT, DATEDIFF, GETDATE, DATEPART)
-- =============================================================================
