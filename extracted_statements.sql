-- =========================================================================
-- EXTRACTED SQL STATEMENTS FROM BOBSBOOKSTORE APPLICATION
-- Microsoft SQL Server to PostgreSQL Migration
-- =========================================================================
-- Total Statements: 5
-- Extraction Date: Step 1 of Migration Plan
-- =========================================================================

-- -------------------------------------------------------------------------
-- Statement 1: Update Author Using Stored Procedure
-- -------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~159
-- Type: Stored Procedure Call with Variable Declaration
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Purpose: Update author personal information using stored procedure uspUpdateAuthorPersonalInfo
-- -------------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- -------------------------------------------------------------------------
-- Statement 2: Select All Authors
-- -------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~178
-- Type: Simple SELECT Statement
-- Parameters: None
-- Purpose: Retrieve all authors from the author table
-- -------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author

-- -------------------------------------------------------------------------
-- Statement 3: Delete Author Using Stored Procedure
-- -------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~198
-- Type: Stored Procedure Call with Variable Declaration
-- Parameters: @BusinessEntityID (int)
-- Purpose: Delete an author using stored procedure uspDeleteAuthor
-- -------------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- -------------------------------------------------------------------------
-- Statement 4: Select Authors by Hire Year with Date Functions
-- -------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~218
-- Type: Complex SELECT with Date Functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- Parameters: @HireDate (int - year value)
-- Purpose: Select authors with formatted modified date and calculated age, filtered by hire year
-- -------------------------------------------------------------------------
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- -------------------------------------------------------------------------
-- Statement 5: Get Product Data Using Stored Procedure
-- -------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~31
-- Type: Stored Procedure Call
-- Parameters: None
-- Purpose: Retrieve all product data using stored procedure uspGetProductData
-- -------------------------------------------------------------------------
EXEC [dbo].[uspGetProductData];

-- =========================================================================
-- END OF EXTRACTED STATEMENTS
-- =========================================================================
-- Summary:
-- - Total Statements Extracted: 5
-- - Stored Procedure Calls: 3 (Statements 1, 3, 5)
-- - Direct SELECT Queries: 2 (Statements 2, 4)
-- - Files Containing SQL: 2 (AuthorsController.cs, ProductsController.cs)
-- =========================================================================
