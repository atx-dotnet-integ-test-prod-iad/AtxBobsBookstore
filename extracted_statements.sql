-- ========================================================================================================
-- SQL STATEMENTS CATALOG - Bob's Bookstore Migration
-- Extracted from .NET Application for DMS Tool Processing
-- Total Statements: 5
-- ========================================================================================================

-- ========================================================================================================
-- STATEMENT 1 OF 5
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Line: 185
-- Type: SELECT statement (inline SQL)
-- Description: Retrieves all authors from the bobsbookstore_dbo.author table
-- Parameters: None
-- ========================================================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ========================================================================================================
-- STATEMENT 2 OF 5
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Line: 163
-- Type: DECLARE + EXEC stored procedure call with output variable
-- Description: Updates author personal information using stored procedure uspUpdateAuthorPersonalInfo
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- ========================================================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ========================================================================================================
-- STATEMENT 3 OF 5
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Line: 205
-- Type: DECLARE + EXEC stored procedure call with output variable
-- Description: Deletes an author using stored procedure uspDeleteAuthor
-- Parameters: @BusinessEntityID (int)
-- ========================================================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ========================================================================================================
-- STATEMENT 4 OF 5
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Line: 221
-- Type: SELECT statement with SQL Server date/time functions
-- Description: Retrieves authors by hire year with formatted dates and age calculation
-- Parameters: @HireDate (int - year value)
-- SQL Server Functions Used: FORMAT(), DATEDIFF(), GETDATE(), DATEPART()
-- ========================================================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ========================================================================================================
-- STATEMENT 5 OF 5
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Line: 31
-- Type: EXEC stored procedure call
-- Description: Retrieves all product data using stored procedure uspGetProductData
-- Parameters: None
-- ========================================================================================================
EXEC [dbo].[uspGetProductData];

-- ========================================================================================================
-- END OF CATALOG
-- Total SQL Statements Extracted: 5
-- All statements are ready for DMS MCP tool processing
-- ========================================================================================================
