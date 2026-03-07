-- ============================================================
-- Extracted Original MS SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Date: 2026-03-07
-- Total Statements: 5
-- ============================================================

-- Statement 1: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
SELECT * FROM [dbo].[Author]

-- Statement 2: EditUsingStoredProcedure (AuthorsController.cs)
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
EXEC [HumanResources].[uspUpdateEmployeePersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [HumanResources].[Employee] WHERE YEAR(HireDate) = @HireDate

-- Statement 5: FindAllProducts (ProductsController.cs)
-- Location: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
EXEC [dbo].[uspGetProductData]
