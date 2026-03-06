-- =============================================================================
-- CONVERTED SQL STATEMENTS - PostgreSQL Equivalents
-- Project: BobsBookstore - SQL Server to PostgreSQL Migration
-- Total Statements: 5
-- Conversion Date: 2026-03-06
-- Last Updated: 2026-03-06 (Step 1 DMS retry)
-- =============================================================================
-- 
-- DMS Tool Results:
--   All 5 statements were passed through the DMS MCP tool (dms-mcp___statement_conversion_tool)
--   All 5 conversions FAILED with error:
--     "Metadata model creation failed: {'error': 'Metadata model creation failed: 
--      {'default_error_details': {'message': 'The selected objects were not found.'}}'}"
--
-- DMS Retry Timestamps:
--   Statement 1: 2026-03-06T09:37:49.510881 (FAILED)
--   Statement 2: 2026-03-06T09:38:05.226302 (FAILED)
--   Statement 3: 2026-03-06T09:38:20.996543 (FAILED)
--   Statement 4: 2026-03-06T09:38:36.580687 (FAILED)
--   Statement 5: 2026-03-06T09:38:52.115738 (FAILED)
--
-- Per transformation rules, all statements manually converted with:
--   - Lowercase schema object names (tables, columns, function names)
--   - SQL Server functions mapped to PostgreSQL equivalents
--   - EXEC stored procedure calls converted to SELECT * FROM function() syntax
--   - Conversion method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- =============================================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs:~167)
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed (retried 2026-03-06T09:37:49)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Details:
--   DECLARE/EXEC/SELECT block -> SELECT * FROM function() call
--   [dbo].[uspUpdateAuthorPersonalInfo] -> uspupdateauthorpersonalinfo (lowercase)
-- Converted PostgreSQL:
SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs:~192)
-- Original MS SQL: SELECT * FROM Author
-- DMS Status: FAILED - Metadata model creation failed (retried 2026-03-06T09:38:05)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Details:
--   Author -> author (lowercase table name)
-- Converted PostgreSQL:
SELECT * FROM author

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs:~210)
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed (retried 2026-03-06T09:38:20)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Details:
--   DECLARE/EXEC/SELECT block -> SELECT * FROM function() call
--   [dbo].[uspDeleteAuthor] -> uspdeleteauthor (lowercase)
-- Converted PostgreSQL:
SELECT * FROM uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs:~228)
-- Original MS SQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Status: FAILED - Metadata model creation failed (retried 2026-03-06T09:38:36)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Details:
--   FORMAT(date, 'yyyy-MM-dd HH:mm:ss') -> TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')
--   DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT
--   DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM hiredate)
--   GETDATE() -> NOW()
--   Author -> author (lowercase table name)
--   BusinessEntityID -> businessentityid (lowercase column names)
--   FormattedModifiedDate -> formattedmodifieddate (lowercase alias)
--   Age -> age (lowercase alias)
-- Converted PostgreSQL:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs:~36)
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED - Metadata model creation failed (retried 2026-03-06T09:38:52)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Details:
--   EXEC [dbo].[uspGetProductData] -> SELECT * FROM uspgetproductdata()
--   [dbo].[uspGetProductData] -> uspgetproductdata (lowercase)
-- Converted PostgreSQL:
SELECT * FROM uspgetproductdata();
