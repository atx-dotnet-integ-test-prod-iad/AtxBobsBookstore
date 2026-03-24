-- Extracted SQL Statements (Original MS SQL Server)
-- Source: BobsBookstore Application
-- Total Statements: 5

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure (line ~163)
-- Method: EditUsingStoredProcedure
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql (line ~187)
-- Method: FindAllAuthorsEmbeddedSql
SELECT * FROM [dbo].[Author]

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql (line ~208)
-- Method: DeleteAuthorEmbeddedSql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear (line ~228)
-- Method: SelectAuthorsByHireYear
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate

-- Statement 5: ProductsController.cs - FindAllProducts (line ~34)
-- Method: FindAllProducts
EXEC [dbo].[uspGetProductData];
