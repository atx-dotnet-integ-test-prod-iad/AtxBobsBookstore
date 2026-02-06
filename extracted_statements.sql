-- ==============================================================================
-- SQL STATEMENTS EXTRACTION CATALOG
-- Migration from Microsoft SQL Server to PostgreSQL
-- ==============================================================================
-- This file contains all SQL statements extracted from the Bob's Bookstore
-- .NET application codebase. Each statement is documented with its source
-- location, context, and type.
-- ==============================================================================

-- ==============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Information
-- ==============================================================================
-- Source File: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 157
-- Method: EditUsingStoredProcedure
-- Type: Stored Procedure Call with DECLARE and EXEC syntax
-- Description: Calls uspUpdateAuthorPersonalInfo stored procedure to update
--              author personal information (NationalIDNumber, BirthDate, 
--              MaritalStatus, Gender) and returns rows affected.
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- ==============================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ==============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- ==============================================================================
-- Source File: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 179
-- Method: FindAllAuthorsEmbeddedSql
-- Type: SELECT statement
-- Description: Retrieves all author records from the bobsbookstore_dbo.author table
-- Parameters: None
-- ==============================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ==============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author
-- ==============================================================================
-- Source File: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 198
-- Method: DeleteAuthorEmbeddedSql
-- Type: Stored Procedure Call with DECLARE and EXEC syntax
-- Description: Calls uspDeleteAuthor stored procedure to delete an author
--              by BusinessEntityID and returns rows affected.
-- Parameters: @BusinessEntityID
-- ==============================================================================

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ==============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Select Authors by Hire Year
-- ==============================================================================
-- Source File: /sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 215
-- Method: SelectAuthorsByHireYear
-- Type: SELECT statement with PostgreSQL date functions
-- Description: Selects authors hired in a specific year, calculating their age
--              and formatting the modified date. NOTE: This statement already
--              uses PostgreSQL-specific syntax (TO_CHAR, EXTRACT, AGE) but must
--              still be validated through DMS and equivalency tools.
-- Parameters: @HireDate (year value)
-- ==============================================================================

SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ==============================================================================
-- STATEMENT 5: FindAllProducts - Get All Product Data
-- ==============================================================================
-- Source File: /sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 31
-- Method: FindAllProducts
-- Type: Stored Procedure Call using EXEC syntax
-- Description: Calls uspGetProductData stored procedure to retrieve all products
-- Parameters: None
-- ==============================================================================

EXEC [dbo].[uspGetProductData];

-- ==============================================================================
-- END OF EXTRACTION CATALOG
-- Total Statements Extracted: 5
-- - Stored Procedure Calls: 3 (Statements 1, 3, 5)
-- - SELECT Statements: 2 (Statements 2, 4)
-- ==============================================================================
