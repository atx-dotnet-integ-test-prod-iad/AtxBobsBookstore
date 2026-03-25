-- ============================================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Purpose: Comprehensive inventory of all SQL statements for DMS conversion
-- Date: 2026-03-25
-- Total Statements: 5
-- ============================================================================

-- ============================================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure (line ~163)
-- Context: Calls stored procedure to update author personal info
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- SQL Type: Stored Procedure Call (EXEC)
-- ============================================================================
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;

-- ============================================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql (line ~187)
-- Context: Retrieves all authors from the Author table
-- Parameters: None
-- SQL Type: SELECT query
-- ============================================================================
SELECT * FROM Author

-- ============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql (line ~208)
-- Context: Calls stored procedure to delete an author
-- Parameters: @BusinessEntityID
-- SQL Type: Stored Procedure Call (EXEC)
-- ============================================================================
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;

-- ============================================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear (line ~228)
-- Context: Selects authors with calculated age, filtered by hire year
-- Parameters: @HireDate
-- SQL Type: SELECT query with SQL Server functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- Statement 5: FindAllProducts
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts (line ~34)
-- Context: Calls stored procedure to get all product data
-- Parameters: None
-- SQL Type: Stored Procedure Call (EXEC)
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- Connection String Pattern (for reference)
-- Source File: sourceCode/app/Bookstore.Web/Startup/ServicesSetup.cs (line ~91)
-- Original Pattern: Server={host},{port}; Initial Catalog=BobsUsedBookStore;MultipleActiveResultSets=true; Integrated Security=false;TrustServerCertificate=True
-- Uses SqlConnectionStringBuilder for UserID/Password
-- ============================================================================
