-- ============================================================
-- Extracted SQL Statements - Original MS SQL Server Statements
-- BobsBookstore SQL Server to PostgreSQL Migration
-- ============================================================
-- Total Statements: 5
-- Source Files: AuthorsController.cs (4), ProductsController.cs (1)
-- ============================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Description: Calls stored procedure to update author personal info, captures rows affected
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Description: Simple SELECT to retrieve all authors
SELECT * FROM Author

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Description: Calls stored procedure to delete an author, captures rows affected
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Description: Selects authors with formatted date and calculated age, filtered by hire year
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs)
-- Source: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Description: Executes stored procedure to get all product data
EXEC [dbo].[uspGetProductData];
