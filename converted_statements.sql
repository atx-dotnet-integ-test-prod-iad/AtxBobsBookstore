-- Converted SQL Statements Catalog
-- Source: MS SQL Server to PostgreSQL Migration
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: "Metadata model creation failed: No objects were found according to the specified selection rules."
-- DMS was attempted for all statements twice (original run + retry) and all failed with the same metadata model creation error
-- Manual conversion applied per transformation definition rules: lowercase schema objects, PostgreSQL function equivalents
-- Generated during SQL Server to PostgreSQL Migration
-- Retry DMS Timestamps: 2026-03-26T14:10:09 through 2026-03-26T14:12:02

-- ============================================================
-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
-- ============================================================
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed (attempted twice)
-- DMS Original Timestamp: 2026-03-26T13:42:08.169705
-- DMS Retry Timestamp: 2026-03-26T14:10:09.570267
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: EXEC stored_proc -> SELECT * FROM function(); all schema objects lowercased
-- Converted PostgreSQL:
SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- ============================================================
-- Original MS SQL: SELECT * FROM Author
-- DMS Status: FAILED - Metadata model creation failed (attempted twice)
-- DMS Original Timestamp: 2026-03-26T13:42:30.704512
-- DMS Retry Timestamp: 2026-03-26T14:10:37.587580
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: Table name Author -> author (lowercase)
-- Converted PostgreSQL:
SELECT * FROM author

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- ============================================================
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed (attempted twice)
-- DMS Original Timestamp: 2026-03-26T13:42:54.709123
-- DMS Retry Timestamp: 2026-03-26T14:11:00.795559
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: EXEC stored_proc -> SELECT * FROM function(); all schema objects lowercased
-- Converted PostgreSQL:
SELECT * FROM uspdeleteauthor(@BusinessEntityID);

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
-- ============================================================
-- Original MS SQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Status: FAILED - Metadata model creation failed (attempted twice)
-- DMS Original Timestamp: 2026-03-26T13:43:18.259354
-- DMS Retry Timestamp: 2026-03-26T14:11:25.431236
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: FORMAT->TO_CHAR, DATEDIFF(YEAR,...)->EXTRACT(YEAR FROM AGE(...)), GETDATE()->NOW(), DATEPART(YEAR,...)->EXTRACT(YEAR FROM ...), all schema objects lowercased
-- Converted PostgreSQL:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================
-- Statement 5: FindAllProducts (ProductsController.cs)
-- ============================================================
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED - Metadata model creation failed (attempted twice)
-- DMS Original Timestamp: 2026-03-26T13:43:43.484273
-- DMS Retry Timestamp: 2026-03-26T14:11:47.818763
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: EXEC stored_proc -> SELECT * FROM function(); all schema objects lowercased
-- Converted PostgreSQL:
SELECT * FROM uspgetproductdata();
