-- ========================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Total Statements: 5
-- ========================================

-- ========================================
-- Statement 1 of 5
-- File: AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: 157
-- Description: Stored procedure call for updating author personal information
-- ========================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int)
-- @NationalIDNumber (string)
-- @BirthDate (DateTime)
-- @MaritalStatus (string)
-- @Gender (string)

-- ========================================
-- Statement 2 of 5
-- File: AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: 177
-- Description: SELECT query to retrieve all authors
-- ========================================
SELECT * FROM bobsbookstore_dbo.author

-- No parameters

-- ========================================
-- Statement 3 of 5
-- File: AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: 196
-- Description: Stored procedure call for deleting an author
-- ========================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int)

-- ========================================
-- Statement 4 of 5
-- File: AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: 214
-- Description: SELECT query with SQL Server specific functions (FORMAT, DATEDIFF, DATEPART, GETDATE)
-- ========================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Parameters:
-- @HireDate (int)

-- ========================================
-- Statement 5 of 5
-- File: ProductsController.cs
-- Method: FindAllProducts
-- Line: 31
-- Description: Stored procedure call to retrieve product data
-- ========================================
EXEC [dbo].[uspGetProductData];

-- No parameters

-- ========================================
-- END OF EXTRACTED STATEMENTS
-- ========================================
