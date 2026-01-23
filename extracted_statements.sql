-- =============================================
-- SQL Statement Extraction Catalog
-- BobsBookstore ADO.NET Application
-- Microsoft SQL Server to PostgreSQL Migration
-- =============================================

-- Total SQL Statements Extracted: 5
-- Extraction Date: 2025-01-23
-- Source Application: BobsBookstore

-- =============================================
-- Statement 1: Update Author Personal Info (Stored Procedure Call)
-- =============================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~160
-- Type: Stored Procedure Execution
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Description: Calls uspUpdateAuthorPersonalInfo stored procedure to update author personal information
-- =============================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- =============================================
-- Statement 2: Find All Authors
-- =============================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~178
-- Type: SELECT Statement
-- Parameters: None
-- Description: Retrieves all authors from the bobsbookstore_dbo.author table
-- =============================================
SELECT * FROM bobsbookstore_dbo.author;

-- =============================================
-- Statement 3: Delete Author (Stored Procedure Call)
-- =============================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~196
-- Type: Stored Procedure Execution
-- Parameters: @BusinessEntityID (int)
-- Description: Calls uspDeleteAuthor stored procedure to delete an author
-- =============================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- =============================================
-- Statement 4: Select Authors By Hire Year with Age Calculation
-- =============================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~210
-- Type: SELECT Statement with SQL Server Functions
-- Parameters: @HireDate (int - year value)
-- Description: Retrieves authors hired in a specific year with formatted modified date and calculated age
-- SQL Server Functions Used: FORMAT, DATEDIFF, GETDATE, DATEPART
-- =============================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- =============================================
-- Statement 5: Get All Products (Stored Procedure Call)
-- =============================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~30
-- Type: Stored Procedure Execution
-- Parameters: None
-- Description: Calls uspGetProductData stored procedure to retrieve all products
-- =============================================
EXEC [dbo].[uspGetProductData];

-- =============================================
-- End of SQL Statement Extraction Catalog
-- =============================================
