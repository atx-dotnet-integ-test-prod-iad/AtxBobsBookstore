-- ============================================================================
-- SQL Statement Extraction Catalog
-- Generated: Migration from Microsoft SQL Server to PostgreSQL
-- ============================================================================
-- This file contains all SQL statements extracted from the BobsBookstore 
-- application codebase for conversion to PostgreSQL.
-- Each statement is documented with:
--   - Source File Path
--   - Method Name
--   - Line Number Reference
--   - Statement Type
--   - Original SQL Text
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Update Author Personal Info using Stored Procedure
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: 155
-- Type: Stored Procedure Call with DECLARE/EXEC pattern
-- Description: Updates author personal information using stored procedure uspUpdateAuthorPersonalInfo
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: Select All Authors
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: 180
-- Type: Simple SELECT query
-- Description: Retrieves all authors from the author table
-- Parameters: None
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- STATEMENT 3: Delete Author using Stored Procedure
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: 201
-- Type: Stored Procedure Call with DECLARE/EXEC pattern
-- Description: Deletes an author using stored procedure uspDeleteAuthor
-- Parameters: @BusinessEntityID (int)
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: 221
-- Type: Complex SELECT with T-SQL functions
-- Description: Retrieves authors hired in specific year with formatted date and age calculation
-- T-SQL Functions Used: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Parameters: @HireDate (int - represents year)
-- ============================================================================
SELECT BusinessEntityID, 
       FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
       DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
FROM bobsbookstore_dbo.author 
WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: Get All Product Data using Stored Procedure
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: 31
-- Type: Stored Procedure Call
-- Description: Retrieves all product data using stored procedure uspGetProductData
-- Parameters: None
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- END OF EXTRACTION CATALOG
-- Total Statements Extracted: 5
-- ============================================================================
