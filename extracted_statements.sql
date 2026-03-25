-- ============================================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Date: 2026-03-25
-- Last Updated: 2026-03-25 (Step 1 - DMS re-attempt #2)
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs ~line 165)
-- Description: Stored procedure call to update author personal info
-- Type: Stored Procedure EXEC call with parameters
-- Original MS SQL:
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs ~line 192)
-- Description: Select all authors from Author table
-- Type: Simple SELECT query
-- Original MS SQL:
SELECT * FROM [dbo].[Author];

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs ~line 207)
-- Description: Stored procedure call to delete an author
-- Type: Stored Procedure EXEC call with parameter
-- Original MS SQL:
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs ~line 229)
-- Description: Select authors with formatted date and age calculation, filtered by hire year
-- Type: SELECT with SQL Server-specific functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- Original MS SQL:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs ~line 36)
-- Description: Stored procedure call to get product data
-- Type: Stored Procedure EXEC call (no parameters)
-- Original MS SQL:
EXEC [dbo].[uspGetProductData];
