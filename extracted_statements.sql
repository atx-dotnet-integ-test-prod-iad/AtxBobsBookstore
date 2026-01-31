-- ============================================================================
-- SQL Statement Extraction Catalog
-- Microsoft SQL Server to PostgreSQL Migration
-- Source: BobsBookstore ADO.NET Application
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Update Author Personal Info via Stored Procedure
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 155
-- Method Name: EditUsingStoredProcedure
-- Purpose: Execute stored procedure to update author personal information
-- Context: Embedded SQL with DECLARE/EXEC pattern for stored procedure call
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- ============================================================================

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: Select All Authors
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 175
-- Method Name: FindAllAuthorsEmbeddedSql
-- Purpose: Retrieve all author records from the database
-- Context: Direct SELECT query with schema-qualified table name
-- Parameters: None
-- ============================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: Delete Author via Stored Procedure
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 195
-- Method Name: DeleteAuthorEmbeddedSql
-- Purpose: Execute stored procedure to delete author record
-- Context: Embedded SQL with DECLARE/EXEC pattern for stored procedure call
-- Parameters: @BusinessEntityID
-- ============================================================================

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 214
-- Method Name: SelectAuthorsByHireYear
-- Purpose: Retrieve authors hired in a specific year with formatted date and age
-- Context: Complex SELECT with SQL Server specific functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- Parameters: @HireDate (year value)
-- SQL Server Functions Used:
--   - FORMAT: Formats date/time value to string
--   - DATEDIFF: Calculates date difference in years
--   - GETDATE: Returns current date/time
--   - DATEPART: Extracts year from date
-- ============================================================================

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: Get All Product Data via Stored Procedure
-- ============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 32
-- Method Name: FindAllProducts
-- Purpose: Execute stored procedure to retrieve all product data
-- Context: Embedded SQL with SQL Server EXEC syntax for stored procedure call
-- Parameters: None
-- SQL Server Syntax Used:
--   - EXEC: Executes stored procedure
--   - [dbo]: SQL Server schema qualification with brackets
-- ============================================================================

EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total SQL Statements Extracted: 5
-- Statements with Stored Procedure Calls: 3 (Statement 1, Statement 3, Statement 5)
-- Statements with Direct Queries: 2 (Statement 2, Statement 4)
-- Statements with SQL Server Specific Functions: 1 (Statement 4)
-- Statements with Parameters: 3 (Statement 1, Statement 3, Statement 4)
-- Schema References: bobsbookstore_dbo (inferred as dbo)
-- Table References: author
-- Stored Procedures Referenced: uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData
-- ============================================================================
