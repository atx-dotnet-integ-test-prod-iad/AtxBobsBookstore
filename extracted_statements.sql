-- ===================================================================
-- SQL STATEMENT EXTRACTION CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- ===================================================================
-- This file documents all SQL statements extracted from the codebase
-- that require conversion from MS SQL Server syntax to PostgreSQL syntax
-- ===================================================================

-- ===================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Stored Procedure Call
-- ===================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~169
-- Type: Stored Procedure Call with DECLARE/EXEC pattern
-- Description: Updates author personal information using stored procedure
-- ===================================================================

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ===================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Simple SELECT
-- ===================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~189
-- Type: Simple SELECT query
-- Description: Retrieves all authors from the database
-- ===================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ===================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure Call
-- ===================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~207
-- Type: Stored Procedure Call with DECLARE/EXEC pattern
-- Description: Deletes an author using stored procedure
-- ===================================================================

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ===================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with T-SQL Functions
-- ===================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~226
-- Type: Complex SELECT with T-SQL date/time functions
-- Description: Retrieves authors by hire year with formatted date and age calculation
-- SQL Server Functions Used: FORMAT, DATEDIFF, GETDATE, DATEPART
-- ===================================================================

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ===================================================================
-- STATEMENT 5: FindAllProducts - Stored Procedure Execution
-- ===================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~32
-- Type: Stored Procedure Execution
-- Description: Retrieves all products using stored procedure
-- ===================================================================

EXEC [dbo].[uspGetProductData];

-- ===================================================================
-- END OF EXTRACTION CATALOG
-- Total Statements Extracted: 5
-- ===================================================================
