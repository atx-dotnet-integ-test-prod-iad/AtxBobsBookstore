-- Extracted SQL Statements from BobsBookstore Application
-- Source: Microsoft SQL Server (original forms before migration)
-- Extraction Date: 2026-03-21

-- ============================================================
-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method (line 163)
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================
-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method (line 187)
-- ============================================================
SELECT * FROM Author

-- ============================================================
-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method (line 208)
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================
-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method (line 228)
-- ============================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================
-- Statement 5: ProductsController.cs - FindAllProducts method (line 34)
-- ============================================================
EXEC [dbo].[uspGetProductData];
