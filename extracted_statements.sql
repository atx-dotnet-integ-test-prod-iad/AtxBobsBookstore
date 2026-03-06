-- ============================================================================
-- Extracted SQL Statements from BobsBookstore Application
-- Source: MS SQL Server
-- Extraction Date: 2026-03-06
-- ============================================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure (line 163)
-- Source Method: EditUsingStoredProcedure
-- Description: Calls stored procedure uspUpdateAuthorPersonalInfo with parameters
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql (line 187)
-- Source Method: FindAllAuthorsEmbeddedSql
-- Description: Simple SELECT to retrieve all authors
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql (line 208)
-- Source Method: DeleteAuthorEmbeddedSql
-- Description: Calls stored procedure uspDeleteAuthor with BusinessEntityID parameter
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear (line 228)
-- Source Method: SelectAuthorsByHireYear
-- Description: SELECT with SQL Server specific functions FORMAT, DATEDIFF, GETDATE, DATEPART
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts (line 34)
-- Source Method: FindAllProducts
-- Description: Calls stored procedure uspGetProductData
EXEC [dbo].[uspGetProductData];
