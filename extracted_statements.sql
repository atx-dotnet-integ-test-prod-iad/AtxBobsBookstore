-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Original Database: Microsoft SQL Server
-- Target Database: PostgreSQL
-- ============================================================================

-- ============================================================================
-- Statement 1
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure (line ~163)
-- Description: Calls stored procedure to update author personal info
-- Original MS SQL Server Statement:
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- Statement 2
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql (line ~187)
-- Description: Selects all authors from the author table
-- Original MS SQL Server Statement:
-- ============================================================================
SELECT * FROM [dbo].[author]

-- ============================================================================
-- Statement 3
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql (line ~208)
-- Description: Calls stored procedure to delete an author
-- Original MS SQL Server Statement:
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- Statement 4
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear (line ~228)
-- Description: Selects authors with computed columns (CONVERT, DATEDIFF, GETDATE, YEAR)
-- Original MS SQL Server Statement:
-- ============================================================================
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.author WHERE YEAR(HireDate) = @HireDate

-- ============================================================================
-- Statement 5
-- File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts (line ~34)
-- Description: Calls stored procedure to get all product data
-- Original MS SQL Server Statement:
-- ============================================================================
EXEC [dbo].[uspGetProductData]
