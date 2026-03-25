-- ============================================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Converted using: AWS DMS MCP Statement Conversion Tool (attempted)
-- Migration Project: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- Date: 2026-03-25
-- Note: DMS tool failed for all statements with error:
--       "Metadata model creation failed: No objects were found according to
--       the specified selection rules. Please review your selection rules
--       and try again."
--       Manual conversion applied with lowercase schema naming per transformation rules.
--       Schema mapping: dbo -> bobsusedbookstore_dbo (lowercase naming convention for PostgreSQL).
-- ============================================================================

-- ============================================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure (line ~163)
-- Original MS SQL: EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- DMS Status: ERROR - Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-25T21:07:18.010366
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Manual Conversion Notes: EXEC -> CALL, [dbo].[uspUpdateAuthorPersonalInfo] -> bobsusedbookstore_dbo.uspupdateauthorpersonalinfo (lowercase)
-- ============================================================================
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql (line ~187)
-- Original MS SQL: SELECT * FROM Author
-- DMS Status: ERROR - Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-25T21:07:42.458210
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Manual Conversion Notes: Author -> bobsusedbookstore_dbo.author (lowercase, schema qualified)
-- ============================================================================
SELECT * FROM bobsusedbookstore_dbo.author;

-- ============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql (line ~208)
-- Original MS SQL: EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- DMS Status: ERROR - Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-25T21:08:11.368888
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Manual Conversion Notes: EXEC -> CALL, [dbo].[uspDeleteAuthor] -> bobsusedbookstore_dbo.uspdeleteauthor (lowercase)
-- ============================================================================
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear (line ~228)
-- Original MS SQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Status: ERROR - Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-25T21:08:35.475712
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Manual Conversion Notes: FORMAT -> to_char, DATEDIFF -> aws_sqlserver_ext.datediff, GETDATE() -> clock_timestamp(),
--   DATEPART -> date_part, Author -> bobsusedbookstore_dbo.author, column names lowercased
-- ============================================================================
SELECT businessentityid, to_char(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;

-- ============================================================================
-- Statement 5: FindAllProducts
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts (line ~34)
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- DMS Status: ERROR - Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-25T21:09:02.296392
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Manual Conversion Notes: EXEC -> CALL, [dbo].[uspGetProductData] -> bobsusedbookstore_dbo.uspgetproductdata (lowercase),
--   added cursor parameter syntax for PostgreSQL stored procedure compatibility
-- ============================================================================
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
