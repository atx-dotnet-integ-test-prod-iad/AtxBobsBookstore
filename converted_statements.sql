-- Converted PostgreSQL Statements for BobsBookstore Application
-- ==============================================================
-- Date: 2026-03-06
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- All 5 DMS conversions failed with: "Metadata model creation failed: {'error': \"Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}\"}"
-- DMS Parameters Used: migration_project_identifier='arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U',
--                       database_name='BobsBookstore', schema_name='dbo', region='us-east-1'
-- Manual conversion applied with lowercase schema object names per transformation rules.

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Attempt Timestamp: 2026-03-06T01:09:58.908921
-- Manual Conversion Rules Applied:
--   - EXEC stored_proc -> SELECT * FROM function_name(params) (PostgreSQL function call syntax)
--   - DECLARE/SELECT @rowsAffected removed (handled by PostgreSQL function return)
--   - Schema and object names lowercased for PostgreSQL compatibility
SELECT * FROM dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql
-- Original MS SQL: SELECT * FROM bobsbookstore_dbo.author
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Attempt Timestamp: 2026-03-06T01:10:24.289591
-- Manual Conversion Rules Applied:
--   - Statement already uses lowercase schema/table names; no functional changes needed
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Attempt Timestamp: 2026-03-06T01:10:47.870967
-- Manual Conversion Rules Applied:
--   - EXEC stored_proc -> SELECT * FROM function_name(params) (PostgreSQL function call syntax)
--   - DECLARE/SELECT @rowsAffected removed (handled by PostgreSQL function return)
--   - Schema and object names lowercased for PostgreSQL compatibility
SELECT * FROM dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear
-- Original MS SQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Attempt Timestamp: 2026-03-06T01:11:12.576888
-- Manual Conversion Rules Applied:
--   - FORMAT(date, 'format') -> TO_CHAR(date, 'format') with PostgreSQL format tokens
--   - DATEDIFF(YEAR, date1, date2) -> EXTRACT(YEAR FROM AGE(date2, date1))::INT
--   - DATEPART(YEAR, date) -> EXTRACT(YEAR FROM date)
--   - GETDATE() -> NOW()
--   - All column/table names lowercased for PostgreSQL compatibility
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Attempt Timestamp: 2026-03-06T01:11:37.000066
-- Manual Conversion Rules Applied:
--   - EXEC stored_proc -> SELECT * FROM function_name() (PostgreSQL function call syntax)
--   - Schema and object names lowercased for PostgreSQL compatibility
SELECT * FROM dbo.uspgetproductdata();
