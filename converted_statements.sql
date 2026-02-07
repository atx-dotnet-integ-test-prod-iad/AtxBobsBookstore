-- =============================================================================
-- SQL STATEMENT CONVERSION CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Date: 2026-02-07
-- =============================================================================
-- This file contains all SQL statements with their PostgreSQL conversions
-- Each statement pair includes the original MS SQL and converted PostgreSQL version
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- =============================================================================

-- =============================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- =============================================================================
-- Source: AuthorsController.cs, EditUsingStoredProcedure method
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: Unknown metadata model creation status: RECEIVED
-- =============================================================================

-- ORIGINAL (MS SQL):
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo($1, $2, $3, $4, $5) AS rows_affected;

-- Conversion Notes:
-- - Replaced DECLARE/EXEC/SELECT pattern with direct function call
-- - Changed parameter syntax from @ParamName to positional parameters ($1, $2, etc.)
-- - Schema qualifier: bobsbookstore_dbo
-- - Parameters: $1=BusinessEntityID, $2=NationalIDNumber, $3=BirthDate, $4=MaritalStatus, $5=Gender

-- =============================================================================
-- STATEMENT 2: Select All Authors (Simple SELECT)
-- =============================================================================
-- Source: AuthorsController.cs, FindAllAuthorsEmbeddedSql method
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: Unknown metadata model creation status: RECEIVED
-- =============================================================================

-- ORIGINAL (MS SQL):
SELECT * FROM bobsbookstore_dbo.author

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author

-- Conversion Notes:
-- - Statement is already PostgreSQL compatible
-- - No changes needed

-- =============================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- =============================================================================
-- Source: AuthorsController.cs, DeleteAuthorEmbeddedSql method
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: Unknown metadata model creation status: RECEIVED
-- =============================================================================

-- ORIGINAL (MS SQL):
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspDeleteAuthor($1) AS rows_affected;

-- Conversion Notes:
-- - Replaced DECLARE/EXEC/SELECT pattern with direct function call
-- - Changed parameter syntax from @BusinessEntityID to $1
-- - Schema qualifier: bobsbookstore_dbo
-- - Parameters: $1=BusinessEntityID

-- =============================================================================
-- STATEMENT 4: Select Authors By Hire Year with Complex Functions
-- =============================================================================
-- Source: AuthorsController.cs, SelectAuthorsByHireYear method
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: Unknown metadata model creation status: RECEIVED
-- =============================================================================

-- ORIGINAL (MS SQL):
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- CONVERTED (PostgreSQL):
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = $1;

-- Conversion Notes:
-- - FORMAT() -> TO_CHAR() with PostgreSQL format string
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) -> DATE_PART('year', AGE(CURRENT_DATE, BirthDate))
-- - GETDATE() -> CURRENT_DATE
-- - DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM HireDate)
-- - @HireDate -> $1
-- - Parameters: $1=HireDate (year value)

-- =============================================================================
-- STATEMENT 5: Get All Products (Stored Procedure Call)
-- =============================================================================
-- Source: ProductsController.cs, FindAllProducts method
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: Unknown metadata model creation status: RECEIVED
-- =============================================================================

-- ORIGINAL (MS SQL):
EXEC [dbo].[uspGetProductData];

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- Conversion Notes:
-- - Replaced EXEC with SELECT * FROM function_name()
-- - Schema qualifier: bobsbookstore_dbo
-- - No parameters

-- =============================================================================
-- END OF CONVERSION CATALOG
-- Total Statement Pairs: 5
-- Conversion Methods:
--   - DMS Tool Success: 0
--   - Manual After DMS Failure: 5
-- =============================================================================
