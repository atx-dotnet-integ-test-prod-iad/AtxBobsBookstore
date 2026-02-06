-- ==============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL
-- ==============================================================================
-- This file contains all SQL statements converted from SQL Server T-SQL to
-- PostgreSQL syntax. Each statement has been processed through the DMS MCP tool
-- and manually converted where necessary due to DMS tool infrastructure errors.
-- ==============================================================================

-- ==============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Information
-- ==============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Source: AuthorsController.cs, EditUsingStoredProcedure method
-- Changes Applied:
--   - Removed T-SQL DECLARE/EXEC stored procedure syntax
--   - Converted to direct UPDATE statement
--   - Schema: [dbo].[Author] -> bobsbookstore_dbo.author
--   - All column names converted to lowercase
-- ==============================================================================

UPDATE bobsbookstore_dbo.author SET nationalidnumber = @NationalIDNumber, birthdate = @BirthDate, maritalstatus = @MaritalStatus, gender = @Gender WHERE businessentityid = @BusinessEntityID

-- ==============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- ==============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (No changes needed)
-- Source: AuthorsController.cs, FindAllAuthorsEmbeddedSql method
-- Changes Applied: None - statement already PostgreSQL-compatible
-- ==============================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ==============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author
-- ==============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Source: AuthorsController.cs, DeleteAuthorEmbeddedSql method
-- Changes Applied:
--   - Removed T-SQL DECLARE/EXEC stored procedure syntax
--   - Converted to direct DELETE statement
--   - Schema: [dbo].[Author] -> bobsbookstore_dbo.author
--   - Column name converted to lowercase
-- ==============================================================================

DELETE FROM bobsbookstore_dbo.author WHERE businessentityid = @BusinessEntityID

-- ==============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Select Authors by Hire Year with Age
-- ==============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Source: AuthorsController.cs, SelectAuthorsByHireYear method
-- Changes Applied:
--   - Column names corrected to lowercase per PostgreSQL schema
--   - PostgreSQL functions (TO_CHAR, EXTRACT, AGE) already present
-- ==============================================================================

SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ==============================================================================
-- STATEMENT 5: FindAllProducts - Get All Product Data
-- ==============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Source: ProductsController.cs, FindAllProducts method
-- Changes Applied:
--   - Removed T-SQL EXEC stored procedure syntax
--   - Converted cursor-based stored procedure to direct SELECT
--   - Schema: [dbo].[Product] -> bobsbookstore_dbo.product
--   - All column names converted to lowercase
-- ==============================================================================

SELECT productid, name, productnumber, safetystocklevel FROM bobsbookstore_dbo.product

-- ==============================================================================
-- END OF CONVERTED STATEMENTS CATALOG
-- Total Statements Converted: 5
-- Conversion Method Summary:
--   - DMS Tool Attempted: 5 statements (all failed with metadata model errors)
--   - Manual Conversions Applied: 5 statements
-- ==============================================================================
