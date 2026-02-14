-- ============================================================================
-- Converted SQL Statements for PostgreSQL
-- Conversion Date: 2026-02-14
-- Purpose: PostgreSQL-converted versions of all SQL statements from extracted_statements.sql
-- Conversion Method: Manual conversion after DMS tool failures
-- ============================================================================

-- ============================================================================
-- STATEMENT 1 (CONVERTED)
-- ============================================================================
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Original SQL: DECLARE @rowsAffected INT; EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender; SELECT @rowsAffected;
-- Conversion Notes: SQL Server stored procedure call with output parameter converted to PostgreSQL function call
-- PostgreSQL functions return values directly, no need for DECLARE/EXEC pattern
-- Schema [dbo] removed as PostgreSQL uses bobsbookstore_dbo schema
-- ============================================================================
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    @BusinessEntityID,
    @NationalIDNumber,
    @BirthDate,
    @MaritalStatus,
    @Gender
);

-- ============================================================================
-- STATEMENT 2 (CONVERTED)
-- ============================================================================
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Original SQL: SELECT * FROM bobsbookstore_dbo.author;
-- Conversion Notes: Schema reference already using PostgreSQL-compatible notation
-- No conversion needed - statement is PostgreSQL compatible
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- STATEMENT 3 (CONVERTED)
-- ============================================================================
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Original SQL: DECLARE @rowsAffected INT; EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID; SELECT @rowsAffected;
-- Conversion Notes: SQL Server stored procedure call with output parameter converted to PostgreSQL function call
-- PostgreSQL functions return values directly, no need for DECLARE/EXEC pattern
-- Schema [dbo] removed as PostgreSQL uses bobsbookstore_dbo schema
-- ============================================================================
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- STATEMENT 4 (CONVERTED)
-- ============================================================================
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Original SQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Conversion Notes: Multiple SQL Server specific functions converted to PostgreSQL equivalents:
--   - FORMAT(date, format) -> TO_CHAR(date, format) with PostgreSQL format codes
--   - DATEDIFF(YEAR, start, end) -> DATE_PART('year', AGE(end, start))
--   - GETDATE() -> CURRENT_TIMESTAMP
--   - DATEPART(YEAR, date) -> EXTRACT(YEAR FROM date) or DATE_PART('year', date)
-- ============================================================================
SELECT 
    "businessentityid", 
    TO_CHAR("modifieddate", 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, 
    DATE_PART('year', AGE(CURRENT_TIMESTAMP, "birthdate")) AS age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM "hiredate") = @HireDate;

-- ============================================================================
-- STATEMENT 5 (CONVERTED)
-- ============================================================================
-- Original File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Original SQL: EXEC [dbo].[uspGetProductData];
-- Conversion Notes: SQL Server stored procedure EXEC converted to PostgreSQL SELECT FROM function
-- Schema [dbo] removed as PostgreSQL uses bobsbookstore_dbo schema
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================================
-- END OF CONVERTED STATEMENTS
-- Total Count: 5 statements
-- Conversion Method: Manual (after DMS tool failures)
-- ============================================================================
