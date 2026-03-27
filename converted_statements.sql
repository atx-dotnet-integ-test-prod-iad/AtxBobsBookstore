-- Converted SQL Statements for PostgreSQL - BobsBookstore Application
-- Target: PostgreSQL
-- Conversion Date: 2026-03-27
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS ARN: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- DMS Parameters: database_name=BobsBookstore, schema_name=dbo, region=us-east-1, server_name=172.31.82.226
-- Manual Conversion Rules Applied:
--   Schema: [dbo].* -> bobsbookstore_dbo.* (lowercase)
--   Functions: CONVERT->TO_CHAR, DATEDIFF->EXTRACT/AGE, GETDATE()->NOW(), YEAR()->EXTRACT(YEAR FROM)
--   Parameters: @ParamName -> $N (positional)
--   Procedures: EXEC proc -> SELECT * FROM function()
--   DECLARE/EXEC pattern -> SELECT * FROM function()

-- ============================================================
-- Statement 1: EditUsingStoredProcedure (CONVERTED - MANUAL)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion: EXEC stored procedure with DECLARE pattern -> PostgreSQL function call with positional parameters
-- Schema Mapping: [dbo].[uspUpdateAuthorPersonalInfo] -> bobsbookstore_dbo.uspupdateauthorpersonalinfo
-- Parameter Mapping: @BusinessEntityID,@NationalIDNumber,@BirthDate,@MaritalStatus,@Gender -> $1,$2,$3,$4,$5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-27T10:31:55.467462
-- DMS Error Timestamp: 2026-03-27T10:32:10.262196
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5);

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql (CONVERTED - MANUAL)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Original MS SQL: SELECT * FROM [dbo].[Author]
-- Conversion: [dbo].[Author] -> bobsbookstore_dbo.author (lowercase schema mapping)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-27T10:32:19.176279
-- DMS Error Timestamp: 2026-03-27T10:32:33.990207
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- ============================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql (CONVERTED - MANUAL)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion: EXEC stored procedure with DECLARE pattern -> PostgreSQL function call with positional parameter
-- Schema Mapping: [dbo].[uspDeleteAuthor] -> bobsbookstore_dbo.uspdeleteauthor
-- Parameter Mapping: @BusinessEntityID -> $1
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-27T10:32:42.193649
-- DMS Error Timestamp: 2026-03-27T10:32:56.763229
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor($1);

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear (CONVERTED - MANUAL)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Original MS SQL: SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireYear;
-- Conversion Details:
--   CONVERT(VARCHAR, ModifiedDate, 120) -> TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')
--   DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(birthdate))::INTEGER
--   YEAR(HireDate) -> EXTRACT(YEAR FROM hiredate)
--   GETDATE() -> removed (AGE() uses current_date implicitly)
--   @HireYear -> $1
--   [dbo].[Author] -> bobsbookstore_dbo.author
--   All column names lowercased: BusinessEntityID->businessentityid, FormattedModifiedDate->formattedmodifieddate, Age->age
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-27T10:33:06.836825
-- DMS Error Timestamp: 2026-03-27T10:33:22.086787
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- ============================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = $1;

-- ============================================================
-- Statement 5: FindAllProducts (CONVERTED - MANUAL)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- Conversion: EXEC stored procedure -> PostgreSQL function call
-- Schema Mapping: [dbo].[uspGetProductData] -> bobsbookstore_dbo.uspgetproductdata
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-27T10:33:31.343853
-- DMS Error Timestamp: 2026-03-27T10:33:46.068445
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
