-- ============================================================================
-- SQL Statement Conversion Catalog
-- Microsoft SQL Server to PostgreSQL Migration
-- Source: BobsBookstore ADO.NET Application
-- DMS MCP Tool + Manual Conversion
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Update Author Personal Info via Stored Procedure
-- ============================================================================
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;
--
-- DMS Conversion Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================

-- PostgreSQL Converted Statement:
-- Note: Stored procedure calls in PostgreSQL use SELECT or PERFORM with function call syntax
-- PostgreSQL functions return values directly, no need for output parameters
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- STATEMENT 2: Select All Authors
-- ============================================================================
-- Original SQL Server Statement:
-- SELECT * FROM bobsbookstore_dbo.author
--
-- DMS Conversion Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================

-- PostgreSQL Converted Statement:
-- Note: Schema.table syntax is compatible between SQL Server and PostgreSQL
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- STATEMENT 3: Delete Author via Stored Procedure
-- ============================================================================
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;
--
-- DMS Conversion Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================

-- PostgreSQL Converted Statement:
-- Note: Stored procedure calls in PostgreSQL use SELECT or PERFORM with function call syntax
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- ============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ============================================================================
-- Original SQL Server Statement:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- DMS Conversion Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- SQL Server to PostgreSQL Function Mappings:
--   FORMAT(date, format) -> TO_CHAR(date, format)
--   DATEDIFF(YEAR, start, end) -> DATE_PART('year', AGE(end, start))
--   GETDATE() -> NOW() or CURRENT_TIMESTAMP
--   DATEPART(YEAR, date) -> EXTRACT(YEAR FROM date)
-- ============================================================================

-- PostgreSQL Converted Statement:
SELECT BusinessEntityID, 
       TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
       DATE_PART('year', AGE(NOW(), BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: Get All Product Data via Stored Procedure
-- ============================================================================
-- Original SQL Server Statement:
-- EXEC [dbo].[uspGetProductData];
--
-- DMS Conversion Status: FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================

-- PostgreSQL Converted Statement:
-- Note: SQL Server EXEC syntax converted to PostgreSQL SELECT FROM function() syntax
-- Stored procedures in PostgreSQL are called as functions
-- For parameterless stored procedures returning result sets, use SELECT * FROM function()
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total SQL Statements Processed: 5
-- Successfully Converted by DMS Tool: 0
-- Manual Conversions After DMS Failure: 5
-- Conversion Notes:
-- 1. All DMS conversions failed with metadata model errors
-- 2. Stored procedure syntax changed from EXEC to SELECT * FROM function()
-- 3. SQL Server specific functions converted to PostgreSQL equivalents (Statement 4)
-- 4. Schema-qualified table names remain compatible
-- 5. Parameter syntax (@param) compatible between SQL Server and PostgreSQL
-- 6. Schema qualification: [dbo] -> bobsbookstore_dbo
-- ============================================================================
