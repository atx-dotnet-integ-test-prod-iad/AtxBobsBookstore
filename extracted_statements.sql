-- =============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- =============================================================================
-- This file contains all SQL statements extracted from the BobsBookstore 
-- .NET application source code for migration from SQL Server to PostgreSQL.
-- =============================================================================
-- Total Statements: 5
-- Source Files: 2 (AuthorsController.cs, ProductsController.cs)
-- Extraction Date: 2026-03-06
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Statement 1: EditUsingStoredProcedure - Update Author Personal Info
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~163
-- Method: EditUsingStoredProcedure
-- Execution Method: ExecuteSqlRawAsync
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- -----------------------------------------------------------------------------
CALL bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- -----------------------------------------------------------------------------
-- Statement 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~187
-- Method: FindAllAuthorsEmbeddedSql
-- Execution Method: SqlQueryRaw<Author>
-- Parameters: None
-- -----------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author;

-- -----------------------------------------------------------------------------
-- Statement 3: DeleteAuthorEmbeddedSql - Delete Author
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~208
-- Method: DeleteAuthorEmbeddedSql
-- Execution Method: ExecuteSqlRawAsync
-- Parameters: @BusinessEntityID
-- -----------------------------------------------------------------------------
CALL bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- -----------------------------------------------------------------------------
-- Statement 4: SelectAuthorsByHireYear - Select Authors by Hire Year with Age Calculation
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~228
-- Method: SelectAuthorsByHireYear
-- Execution Method: SqlQueryRaw<AuthorAgeResult>
-- Parameters: @HireDate
-- -----------------------------------------------------------------------------
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM CURRENT_DATE)::INT - EXTRACT(YEAR FROM birthdate)::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- -----------------------------------------------------------------------------
-- Statement 5: FindAllProducts - Get Product Data via Function
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: ~34
-- Method: FindAllProducts
-- Execution Method: SqlQueryRaw<Product>
-- Parameters: None
-- -----------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- =============================================================================
-- END OF EXTRACTED STATEMENTS
-- =============================================================================
