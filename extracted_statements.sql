-- ================================================================================
-- SQL Statement Extraction Catalog
-- Microsoft SQL Server to PostgreSQL Migration
-- ================================================================================
-- This file contains all SQL statements extracted from the codebase for 
-- conversion to PostgreSQL syntax using the DMS MCP tool.
-- ================================================================================

-- ================================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~162
-- Type: Stored Procedure Execution with DECLARE and variable assignment
-- Construction: Direct string literal
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- Context: ExecuteSqlRawAsync with SqlParameter array
-- ================================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ================================================================================
-- STATEMENT 2: Select All Authors
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~181
-- Type: Simple SELECT query
-- Construction: Direct string literal
-- Parameters: None
-- Context: SqlQueryRaw<Author>
-- ================================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ================================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~200
-- Type: Stored Procedure Execution with DECLARE and variable assignment
-- Construction: Direct string literal
-- Parameters: @BusinessEntityID
-- Context: ExecuteSqlRawAsync with SqlParameter
-- ================================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ================================================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~217
-- Type: Complex SELECT with FORMAT, DATEDIFF, DATEPART, GETDATE functions
-- Construction: Direct string literal
-- Parameters: @HireDate
-- Context: SqlQueryRaw<AuthorAgeResult> with SqlParameter
-- ================================================================================

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ================================================================================
-- STATEMENT 5: Get All Products (Stored Procedure Call)
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~31
-- Type: Stored Procedure Execution
-- Construction: Direct string literal
-- Parameters: None
-- Context: SqlQueryRaw<Product>
-- ================================================================================

EXEC [dbo].[uspGetProductData];

-- ================================================================================
-- END OF EXTRACTION CATALOG
-- Total Statements Extracted: 5
-- ================================================================================
