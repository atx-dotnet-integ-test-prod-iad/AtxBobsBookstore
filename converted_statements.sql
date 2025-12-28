-- ========================================================================================================
-- CONVERTED SQL STATEMENTS CATALOG - Bob's Bookstore Migration
-- Converted from SQL Server to PostgreSQL Syntax
-- All statements processed through DMS MCP Tool
-- Total Statements: 5
-- ========================================================================================================

-- ========================================================================================================
-- STATEMENT 1 OF 5 - CONVERSION
-- Source: AuthorsController.cs - FindAllAuthorsEmbeddedSql() method
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
-- ========================================================================================================

-- ORIGINAL SQL SERVER STATEMENT:
-- SELECT * FROM bobsbookstore_dbo.author

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Timestamp: 2025-12-28T12:12:23.189076

-- POSTGRESQL CONVERTED STATEMENT:
SELECT * FROM bobsbookstore_dbo.author

-- CONVERSION NOTES:
-- Simple SELECT statement is compatible with PostgreSQL syntax.
-- Table name bobsbookstore_dbo.author is preserved as-is (no schema changes from DMS).
-- No SQL Server specific functions to convert.

-- ========================================================================================================
-- STATEMENT 2 OF 5 - CONVERSION
-- Source: AuthorsController.cs - EditUsingStoredProcedure() method
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
-- ========================================================================================================

-- ORIGINAL SQL SERVER STATEMENT:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Timestamp: 2025-12-28T12:12:47.911895

-- POSTGRESQL CONVERTED STATEMENT:
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender)

-- CONVERSION NOTES:
-- SQL Server DECLARE/EXEC pattern converted to PostgreSQL function call using SELECT.
-- DECLARE @rowsAffected INT is removed - PostgreSQL functions return values directly.
-- T-SQL EXEC with return value converted to SELECT function_name(params).
-- Stored procedure name converted to lowercase following PostgreSQL conventions.
-- Schema prefix bobsbookstore_dbo preserved.
-- Parameters maintain @ prefix for compatibility with Npgsql.

-- ========================================================================================================
-- STATEMENT 3 OF 5 - CONVERSION
-- Source: AuthorsController.cs - DeleteAuthorEmbeddedSql() method
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
-- ========================================================================================================

-- ORIGINAL SQL SERVER STATEMENT:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Timestamp: 2025-12-28T12:13:09.937382

-- POSTGRESQL CONVERTED STATEMENT:
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID)

-- CONVERSION NOTES:
-- SQL Server DECLARE/EXEC pattern converted to PostgreSQL function call using SELECT.
-- DECLARE @rowsAffected INT is removed - PostgreSQL functions return values directly.
-- T-SQL EXEC with return value converted to SELECT function_name(params).
-- Stored procedure name converted to lowercase following PostgreSQL conventions.
-- Schema prefix bobsbookstore_dbo preserved.
-- Parameters maintain @ prefix for compatibility with Npgsql.

-- ========================================================================================================
-- STATEMENT 4 OF 5 - CONVERSION
-- Source: AuthorsController.cs - SelectAuthorsByHireYear() method
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
-- ========================================================================================================

-- ORIGINAL SQL SERVER STATEMENT:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Timestamp: 2025-12-28T12:13:33.283649

-- POSTGRESQL CONVERTED STATEMENT:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- CONVERSION NOTES:
-- FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') converted to TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS')
-- DATEDIFF(YEAR, BirthDate, GETDATE()) converted to EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))
-- GETDATE() converted to CURRENT_DATE
-- DATEPART(YEAR, HireDate) converted to EXTRACT(YEAR FROM HireDate)
-- Table name bobsbookstore_dbo.author preserved.
-- Parameters maintain @ prefix for compatibility with Npgsql.

-- ========================================================================================================
-- STATEMENT 5 OF 5 - CONVERSION
-- Source: ProductsController.cs - FindAllProducts() method
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: ERROR - Metadata model creation failed
-- ========================================================================================================

-- ORIGINAL SQL SERVER STATEMENT:
-- EXEC [dbo].[uspGetProductData];

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Timestamp: 2025-12-28T12:13:56.291002

-- POSTGRESQL CONVERTED STATEMENT:
SELECT * FROM bobsbookstore_dbo.uspgetproductdata()

-- CONVERSION NOTES:
-- SQL Server EXEC stored procedure converted to PostgreSQL function call using SELECT * FROM.
-- Stored procedure name converted to lowercase following PostgreSQL conventions.
-- Schema prefix bobsbookstore_dbo preserved.
-- No parameters required for this stored procedure.
-- Added () to indicate function call.

-- ========================================================================================================
-- END OF CONVERTED CATALOG
-- Total SQL Statements Converted: 5
-- DMS Tool Successful Conversions: 0
-- Manual Conversions After DMS Failure: 5
-- All statements are ready for SQL Equivalency validation
-- ========================================================================================================
