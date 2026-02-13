-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Extraction Date: 2026-02-13
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Info
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: 164
-- Context: Stored procedure call to update author personal information
-- SQL Statement Type: EXEC stored procedure with DECLARE and SELECT
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Retrieve All Authors
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: 186
-- Context: SELECT all authors from the author table
-- SQL Statement Type: SELECT
-- Parameters: None
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author via Stored Procedure
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: 206
-- Context: Stored procedure call to delete an author
-- SQL Statement Type: EXEC stored procedure with DECLARE and SELECT
-- Parameters: @BusinessEntityID (int)
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Select Authors with Age Calculation
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: 226
-- Context: SELECT authors by hire year with SQL Server-specific functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- SQL Statement Type: SELECT with SQL Server date functions
-- Parameters: @HireDate (int) - representing the year
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: FindAllProducts - Retrieve All Products via Stored Procedure
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Number: 31
-- Context: Stored procedure call to retrieve all product data
-- SQL Statement Type: EXEC stored procedure
-- Parameters: None
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total SQL Statements Extracted: 5
-- Stored Procedure Calls: 3 (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
-- SELECT Statements: 2 (FindAllAuthorsEmbeddedSql, SelectAuthorsByHireYear)
-- SQL Server Specific Functions: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Schema References: bobsbookstore_dbo, dbo
-- ============================================================================
