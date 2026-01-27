-- ========================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Date: 2026-01-27
-- ========================================================================
-- This catalog contains all SQL statements after conversion from SQL Server
-- to PostgreSQL syntax. Each statement includes the original, converted version,
-- conversion method, and DMS tool output.
-- ========================================================================

-- ========================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Info
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Timestamp: 2026-01-27T23:16:02.650994
-- ========================================================================

-- ORIGINAL SQL SERVER STATEMENT:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] 
--     @BusinessEntityID, 
--     @NationalIDNumber, 
--     @BirthDate, 
--     @MaritalStatus, 
--     @Gender;
-- SELECT @rowsAffected;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: 
--        {'default_error_details': {'message': 'The selected objects were not found.'}}"}

-- CONVERTED POSTGRESQL STATEMENT:
SELECT public.uspUpdateAuthorPersonalInfo(
    @BusinessEntityID, 
    @NationalIDNumber, 
    @BirthDate, 
    @MaritalStatus, 
    @Gender
);

-- SCHEMA CHANGES: [dbo] → public
-- NOTES: Stored procedure must be created in PostgreSQL database

-- ========================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Timestamp: 2026-01-27T23:16:26.660426
-- ========================================================================

-- ORIGINAL SQL SERVER STATEMENT:
-- SELECT * FROM bobsbookstore_dbo.author;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: 
--        {'default_error_details': {'message': 'The selected objects were not found.'}}"}

-- CONVERTED POSTGRESQL STATEMENT:
SELECT * FROM bobsbookstore_dbo.author;

-- SCHEMA CHANGES: None (schema name preserved)
-- NOTES: Minimal changes needed; schema preserved pending migration confirmation

-- ========================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Timestamp: 2026-01-27T23:16:50.864906
-- ========================================================================

-- ORIGINAL SQL SERVER STATEMENT:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] 
--     @BusinessEntityID;
-- SELECT @rowsAffected;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: 
--        {'default_error_details': {'message': 'The selected objects were not found.'}}"}

-- CONVERTED POSTGRESQL STATEMENT:
SELECT public.uspDeleteAuthor(@BusinessEntityID);

-- SCHEMA CHANGES: [dbo] → public
-- NOTES: Stored procedure must be created in PostgreSQL database

-- ========================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex Query with Date Functions
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Timestamp: 2026-01-27T23:17:15.518029
-- ========================================================================

-- ORIGINAL SQL SERVER STATEMENT:
-- SELECT 
--     BusinessEntityID, 
--     FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
--     DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
-- FROM bobsbookstore_dbo.author 
-- WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: 
--        {'default_error_details': {'message': 'The selected objects were not found.'}}"}

-- CONVERTED POSTGRESQL STATEMENT:
SELECT 
    BusinessEntityID, 
    TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
    EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- SYNTAX TRANSFORMATIONS:
-- FORMAT(date, format) → TO_CHAR(date, format)
-- DATEDIFF(YEAR, BirthDate, GETDATE()) → EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate))
-- DATEPART(YEAR, HireDate) → EXTRACT(YEAR FROM HireDate)
-- GETDATE() → CURRENT_TIMESTAMP
-- SCHEMA CHANGES: None (schema name preserved)

-- ========================================================================
-- STATEMENT 5: FindAllProducts - Get Product Data via Stored Procedure
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Timestamp: 2026-01-27T23:17:38.225438
-- ========================================================================

-- ORIGINAL SQL SERVER STATEMENT:
-- EXEC [dbo].[uspGetProductData];

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: 
--        {'default_error_details': {'message': 'The selected objects were not found.'}}"}

-- CONVERTED POSTGRESQL STATEMENT:
SELECT * FROM public.uspGetProductData();

-- SCHEMA CHANGES: [dbo] → public
-- NOTES: Stored procedure must be created as function in PostgreSQL database

-- ========================================================================
-- CONVERSION STATISTICS
-- ========================================================================
-- Total Statements Processed: 5
-- Successfully Converted by DMS Tool: 0
-- Manually Converted After DMS Failure: 5
-- 
-- Conversion Success Rate: 0% (DMS), 100% (Manual)
-- 
-- Common Schema Transformations:
-- - [dbo].object → public.object (3 stored procedures)
-- - bobsbookstore_dbo.table → bobsbookstore_dbo.table (2 tables - preserved)
-- 
-- Key Syntax Transformations Applied:
-- - EXEC stored_proc → SELECT function_name() or SELECT * FROM function_name()
-- - FORMAT() → TO_CHAR()
-- - DATEDIFF() → EXTRACT(YEAR FROM AGE())
-- - DATEPART() → EXTRACT()
-- - GETDATE() → CURRENT_TIMESTAMP
-- - [schema].[object] → schema.object
-- 
-- ========================================================================
-- END OF CONVERTED STATEMENTS CATALOG
-- ========================================================================
