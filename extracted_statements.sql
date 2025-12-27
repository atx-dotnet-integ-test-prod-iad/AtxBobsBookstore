-- ================================================================================
-- SQL STATEMENT EXTRACTION CATALOG
-- Bob's Bookstore - SQL Server to PostgreSQL Migration
-- ================================================================================
-- This catalog contains ALL SQL statements extracted from the codebase
-- Each statement is documented with source location, type, and parameters
-- ================================================================================

-- ================================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ================================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 163
-- Method: EditUsingStoredProcedure
-- Statement Type: Stored Procedure Call with DECLARE and EXEC
-- SQL Syntax: Inline string with parameterized query
-- Parameters:
--   @BusinessEntityID (int) - businessEntityId
--   @NationalIDNumber (string) - nationalIdNumber
--   @BirthDate (DateTime) - birthDate.ToUniversalTime()
--   @MaritalStatus (string) - maritalStatus
--   @Gender (string) - gender
-- Context: Wrapped in try-catch block, uses ExecuteSqlRawAsync
-- SQL Server Specific Syntax:
--   - DECLARE @rowsAffected INT
--   - EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo]
--   - Schema notation: [dbo].[procedurename]
--   - Output parameter capture using DECLARE/EXEC pattern
-- ================================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ================================================================================
-- STATEMENT 2: Find All Authors (SELECT Query)
-- ================================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 188
-- Method: FindAllAuthorsEmbeddedSql
-- Statement Type: SELECT
-- SQL Syntax: Inline string, no parameters
-- Parameters: None
-- Context: Wrapped in try-catch block, uses SqlQueryRaw<Author>
-- SQL Server Specific Syntax:
--   - Schema notation: bobsbookstore_dbo.author
-- ================================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ================================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ================================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 207
-- Method: DeleteAuthorEmbeddedSql
-- Statement Type: Stored Procedure Call with DECLARE and EXEC
-- SQL Syntax: Inline string with parameterized query
-- Parameters:
--   @BusinessEntityID (int) - businessEntityId
-- Context: Wrapped in try-catch block, uses ExecuteSqlRawAsync
-- SQL Server Specific Syntax:
--   - DECLARE @rowsAffected INT
--   - EXEC @rowsAffected = [dbo].[uspDeleteAuthor]
--   - Schema notation: [dbo].[procedurename]
--   - Output parameter capture using DECLARE/EXEC pattern
-- ================================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ================================================================================
-- STATEMENT 4: Select Authors by Hire Year (Complex SELECT with SQL Server Functions)
-- ================================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 225
-- Method: SelectAuthorsByHireYear
-- Statement Type: SELECT with SQL Server-specific functions
-- SQL Syntax: Inline string with parameterized query
-- Parameters:
--   @HireDate (int) - hireYear
-- Context: Wrapped in try-catch block, uses SqlQueryRaw<AuthorAgeResult>
-- SQL Server Specific Syntax:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') - SQL Server date formatting function
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) - SQL Server date difference function
--   - GETDATE() - SQL Server current date/time function
--   - DATEPART(YEAR, HireDate) - SQL Server date part extraction function
--   - Schema notation: bobsbookstore_dbo.author
-- Expected PostgreSQL Conversions:
--   - FORMAT() -> TO_CHAR()
--   - DATEDIFF() -> AGE() or date arithmetic with EXTRACT
--   - GETDATE() -> CURRENT_TIMESTAMP or NOW()
--   - DATEPART() -> EXTRACT()
-- ================================================================================

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ================================================================================
-- STATEMENT 5: Get Product Data (Stored Procedure Call)
-- ================================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 30
-- Method: FindAllProducts
-- Statement Type: Stored Procedure Call with EXEC
-- SQL Syntax: Inline string, no parameters
-- Parameters: None
-- Context: Wrapped in try-catch block, uses SqlQueryRaw<Product>
-- SQL Server Specific Syntax:
--   - EXEC [dbo].[uspGetProductData]
--   - Schema notation: [dbo].[procedurename]
-- ================================================================================

EXEC [dbo].[uspGetProductData];

-- ================================================================================
-- EXTRACTION SUMMARY
-- ================================================================================
-- Total SQL Statements Extracted: 5
-- Statement Types:
--   - Stored Procedure Calls: 3 (Statements 1, 3, 5)
--   - SELECT Queries: 2 (Statements 2, 4)
-- Files Containing SQL:
--   - AuthorsController.cs: 4 statements
--   - ProductsController.cs: 1 statement
-- SQL Server Specific Features Identified:
--   - DECLARE statements for variables
--   - EXEC statements for stored procedures
--   - Schema notation: [dbo].[name]
--   - Functions: FORMAT(), DATEDIFF(), GETDATE(), DATEPART()
--   - Output parameter patterns
-- ================================================================================
