-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Original Database: Microsoft SQL Server
-- Target Database: PostgreSQL
-- Total Statements: 5
-- Extraction Date: 2026-03-06

-- ============================================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~163)
-- Context: Calls stored procedure uspUpdateAuthorPersonalInfo to update author
--          personal information (NationalIDNumber, BirthDate, MaritalStatus, Gender)
-- ADO.NET Method: ExecuteSqlRawAsync with NpgsqlParameter
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~187)
-- Context: Selects all authors from the author table using embedded SQL
-- ADO.NET Method: SqlQueryRaw<Author>
-- Parameters: None
-- ============================================================================
SELECT * FROM "bobsbookstore_dbo"."author"

-- ============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~208)
-- Context: Calls stored procedure uspDeleteAuthor to delete an author by ID
-- ADO.NET Method: ExecuteSqlRawAsync with NpgsqlParameter
-- Parameters: @BusinessEntityID
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~228)
-- Context: Complex query selecting authors by hire year with formatted date 
--          and calculated age using FORMAT, DATEDIFF, GETDATE, DATEPART
-- ADO.NET Method: SqlQueryRaw<AuthorAgeResult> with NpgsqlParameter
-- Parameters: @HireDate
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM "bobsbookstore_dbo"."author" WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs (line ~34)
-- Context: Calls stored procedure uspGetProductData to retrieve all product data
-- ADO.NET Method: SqlQueryRaw<Product>
-- Parameters: None
-- ============================================================================
EXEC [dbo].[uspGetProductData];
