-- ========================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Date: 2026-01-27
-- ========================================================================
-- This catalog contains all SQL statements extracted from the codebase
-- for conversion using the DMS MCP tool and validation using the SQL
-- Equivalency tool.
-- ========================================================================

-- ========================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Info
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 160-171
-- Method: EditUsingStoredProcedure
-- Statement Type: Stored Procedure Call with Output Variable
-- Purpose: Update author personal information using stored procedure
-- Parameters:
--   @BusinessEntityID (int) - Author's business entity ID
--   @NationalIDNumber (string) - National ID number
--   @BirthDate (DateTime) - Birth date (converted to UTC)
--   @MaritalStatus (string) - Marital status
--   @Gender (string) - Gender
-- Notes: Uses DECLARE for output variable @rowsAffected
-- ========================================================================

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] 
    @BusinessEntityID, 
    @NationalIDNumber, 
    @BirthDate, 
    @MaritalStatus, 
    @Gender;
SELECT @rowsAffected;

-- ========================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 181-182
-- Method: FindAllAuthorsEmbeddedSql
-- Statement Type: Simple SELECT statement
-- Purpose: Retrieve all authors from the author table
-- Parameters: None
-- Schema: bobsbookstore_dbo
-- Table: author
-- Notes: Uses schema-qualified table name
-- ========================================================================

SELECT * FROM bobsbookstore_dbo.author;

-- ========================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 199-200
-- Method: DeleteAuthorEmbeddedSql
-- Statement Type: Stored Procedure Call with Output Variable
-- Purpose: Delete an author using stored procedure
-- Parameters:
--   @BusinessEntityID (int) - Author's business entity ID to delete
-- Notes: Uses DECLARE for output variable @rowsAffected
-- ========================================================================

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] 
    @BusinessEntityID;
SELECT @rowsAffected;

-- ========================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex Query with Date Functions
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 217-218
-- Method: SelectAuthorsByHireYear
-- Statement Type: Complex SELECT with SQL Server-specific functions
-- Purpose: Select authors by hire year with formatted date and calculated age
-- Parameters:
--   @HireDate (int) - Year value for filtering hire date
-- SQL Server Functions Used:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss'): Formats date as string
--   - DATEDIFF(YEAR, BirthDate, GETDATE()): Calculates age in years
--   - DATEPART(YEAR, HireDate): Extracts year from hire date
--   - GETDATE(): Returns current date and time
-- Schema: bobsbookstore_dbo
-- Table: author
-- Notes: Contains multiple SQL Server-specific date functions requiring conversion
-- ========================================================================

SELECT 
    BusinessEntityID, 
    FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
FROM bobsbookstore_dbo.author 
WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ========================================================================
-- STATEMENT 5: FindAllProducts - Get Product Data via Stored Procedure
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Numbers: 32
-- Method: FindAllProducts
-- Statement Type: Stored Procedure Call
-- Purpose: Retrieve all products using stored procedure
-- Parameters: None
-- Schema: dbo
-- Stored Procedure: uspGetProductData
-- Notes: Simple stored procedure call without parameters
-- ========================================================================

EXEC [dbo].[uspGetProductData];

-- ========================================================================
-- END OF EXTRACTED STATEMENTS CATALOG
-- Total Statements: 5
-- ========================================================================
