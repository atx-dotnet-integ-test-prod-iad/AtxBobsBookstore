-- ============================================================================
-- SQL Statement Extraction Catalog
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2024
-- ============================================================================

-- Statement ID: STMT_001
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 162
-- Statement Type: STORED_PROC
-- Context: EditUsingStoredProcedure method - Updates author personal information using stored procedure
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement ID: STMT_002
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 185
-- Statement Type: SELECT
-- Context: FindAllAuthorsEmbeddedSql method - Retrieves all authors from database
-- Parameters: None
SELECT * FROM bobsbookstore_dbo.author

-- Statement ID: STMT_003
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 207
-- Statement Type: STORED_PROC
-- Context: DeleteAuthorEmbeddedSql method - Deletes author using stored procedure
-- Parameters: @BusinessEntityID (int)
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement ID: STMT_004
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 227
-- Statement Type: SELECT
-- Context: SelectAuthorsByHireYear method - Selects authors by hire year with T-SQL date functions
-- Parameters: @HireDate (int - year)
-- T-SQL Functions Used: FORMAT, DATEDIFF, GETDATE, DATEPART
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- Summary Statistics
-- ============================================================================
-- Total SQL Statements Identified: 4
-- Stored Procedure Calls: 2
-- SELECT Statements: 2
-- INSERT Statements: 0
-- UPDATE Statements: 0
-- DELETE Statements: 0
-- Transaction Blocks: 0
-- ============================================================================
