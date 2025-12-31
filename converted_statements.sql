-- ============================================================================
-- SQL Statement Conversion Catalog
-- Generated: Step 2 of SQL Server to PostgreSQL Migration
-- Purpose: Document all SQL statement conversions with DMS outputs and PostgreSQL equivalents
-- ============================================================================

-- ============================================================================
-- Statement ID: 1
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: EditUsingStoredProcedure
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================

-- ORIGINAL SQL SERVER STATEMENT:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Timestamp: 2025-12-31T04:17:50.273489
-- Input Parameters Used:
--   migration_project_identifier: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
--   database_name: BobsBookstore
--   schema_name: dbo
--   region: us-east-1
--   server_name: 172.31.82.226

-- MANUAL CONVERSION REASONING:
-- The stored procedure uspUpdateAuthorPersonalInfo performs an UPDATE on the Author table.
-- In PostgreSQL, stored procedures with return values are better implemented as functions.
-- However, since the application already uses ExecuteSqlRawAsync, we'll convert this to a
-- direct PostgreSQL function call or inline SQL that returns affected row count.
-- The schema bobsbookstore_dbo is already being used in the application.
-- PostgreSQL function call syntax: SELECT function_name(params)
-- Based on the procedure definition, this is a simple UPDATE statement.

-- CONVERTED POSTGRESQL STATEMENT:
-- Option 1: Direct function call (if function exists in PostgreSQL):
SELECT bobsbookstore_dbo.usp_update_author_personal_info($1, $2, $3, $4, $5);

-- Option 2: Inline UPDATE (preferred for ExecuteSqlRawAsync compatibility):
UPDATE bobsbookstore_dbo.author 
SET "NationalIDNumber" = $2, 
    "BirthDate" = $3, 
    "MaritalStatus" = $4, 
    "Gender" = $5,
    "ModifiedDate" = NOW()
WHERE "BusinessEntityID" = $1;

-- SCHEMA CHANGES: 
-- Table: dbo.Author -> bobsbookstore_dbo.author
-- Stored procedure: [dbo].[uspUpdateAuthorPersonalInfo] -> bobsbookstore_dbo.usp_update_author_personal_info (if function exists)
-- Column identifiers may need double quotes in PostgreSQL if they contain mixed case


-- ============================================================================
-- Statement ID: 2
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: DeleteAuthorEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================

-- ORIGINAL SQL SERVER STATEMENT:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Timestamp: 2025-12-31T04:17:50.273489 (similar error as Statement 1)

-- MANUAL CONVERSION REASONING:
-- The stored procedure uspDeleteAuthor performs a DELETE on the Author table.
-- Converting to inline DELETE statement for PostgreSQL compatibility.
-- The procedure checks @@ROWCOUNT which can be handled by ExecuteSqlRawAsync return value.

-- CONVERTED POSTGRESQL STATEMENT:
-- Option 1: Direct function call (if function exists):
SELECT bobsbookstore_dbo.usp_delete_author($1);

-- Option 2: Inline DELETE (preferred for ExecuteSqlRawAsync compatibility):
DELETE FROM bobsbookstore_dbo.author 
WHERE "BusinessEntityID" = $1;

-- SCHEMA CHANGES:
-- Table: dbo.Author -> bobsbookstore_dbo.author
-- Stored procedure: [dbo].[uspDeleteAuthor] -> bobsbookstore_dbo.usp_delete_author (if function exists)


-- ============================================================================
-- Statement ID: 3
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: FindAllAuthorsEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================

-- ORIGINAL SQL SERVER STATEMENT:
SELECT * FROM bobsbookstore_dbo.author

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Timestamp: 2025-12-31T04:18:17.201816
-- Input Parameters Used:
--   migration_project_identifier: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
--   database_name: BobsBookstore
--   schema_name: dbo
--   region: us-east-1
--   server_name: 172.31.82.226

-- MANUAL CONVERSION REASONING:
-- This is a simple SELECT statement that is already PostgreSQL compatible.
-- The schema notation bobsbookstore_dbo is already correct for PostgreSQL.
-- No changes needed except possibly column name quoting if there are case-sensitive names.

-- CONVERTED POSTGRESQL STATEMENT:
SELECT * FROM bobsbookstore_dbo.author;

-- SCHEMA CHANGES:
-- None - statement is already compatible


-- ============================================================================
-- Statement ID: 4
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: SelectAuthorsByHireYear
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================

-- ORIGINAL SQL SERVER STATEMENT:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Timestamp: 2025-12-31T04:19:05.263438
-- Input Parameters Used:
--   migration_project_identifier: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
--   database_name: BobsBookstore
--   schema_name: dbo
--   region: us-east-1
--   server_name: 172.31.82.226

-- MANUAL CONVERSION REASONING:
-- This statement uses multiple SQL Server specific functions that need PostgreSQL equivalents:
-- 1. FORMAT(date, format) -> TO_CHAR(date, format) in PostgreSQL
-- 2. DATEDIFF(YEAR, date1, date2) -> DATE_PART('year', AGE(date2, date1)) in PostgreSQL
-- 3. DATEPART(YEAR, date) -> EXTRACT(YEAR FROM date) in PostgreSQL
-- 4. GETDATE() -> NOW() or CURRENT_TIMESTAMP in PostgreSQL
-- Format string needs to be converted from .NET format to PostgreSQL format

-- CONVERTED POSTGRESQL STATEMENT:
SELECT "BusinessEntityID", 
       TO_CHAR("ModifiedDate", 'YYYY-MM-DD HH24:MI:SS') AS "FormattedModifiedDate", 
       DATE_PART('year', AGE(NOW(), "BirthDate"))::INTEGER AS "Age" 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM "HireDate") = $1;

-- SCHEMA CHANGES:
-- None - schema notation remains the same
-- FUNCTION MAPPINGS:
-- FORMAT(date, 'yyyy-MM-dd HH:mm:ss') -> TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')
-- DATEDIFF(YEAR, BirthDate, GETDATE()) -> DATE_PART('year', AGE(NOW(), BirthDate))
-- DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM HireDate)
-- GETDATE() -> NOW()


-- ============================================================================
-- Statement ID: 5
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method Name: FindAllProducts
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- ============================================================================

-- ORIGINAL SQL SERVER STATEMENT:
EXEC [dbo].[uspGetProductData];

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Timestamp: 2025-12-31T04:19:27.177067
-- Input Parameters Used:
--   migration_project_identifier: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
--   database_name: BobsBookstore
--   schema_name: dbo
--   region: us-east-1
--   server_name: 172.31.82.226

-- MANUAL CONVERSION REASONING:
-- The stored procedure uspGetProductData returns a cursor with product data.
-- In PostgreSQL, cursor-based procedures are rarely needed for simple queries.
-- The procedure simply selects ProductID, Name, ProductNumber, SafetyStockLevel from Product table.
-- Best practice: Convert to direct SELECT statement instead of procedure call.
-- This provides better performance and is more idiomatic in PostgreSQL.

-- CONVERTED POSTGRESQL STATEMENT:
-- Option 1: Direct function call (if converted function exists):
SELECT * FROM bobsbookstore_dbo.usp_get_product_data();

-- Option 2: Direct SELECT (preferred - replace cursor-based procedure):
SELECT "ProductID", "Name", "ProductNumber", "SafetyStockLevel"
FROM bobsbookstore_dbo.product;

-- SCHEMA CHANGES:
-- Table: dbo.Product -> bobsbookstore_dbo.product
-- Stored procedure: [dbo].[uspGetProductData] -> bobsbookstore_dbo.usp_get_product_data (if function exists)
-- Recommendation: Use direct SELECT instead of function call for better performance


-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total Statements Converted: 5
-- DMS Tool Successful Conversions: 0
-- Manual Conversions After DMS Failure: 5
-- 
-- DMS Failure Reason (All Statements): Metadata model creation failed - 
--   "No objects were found according to the specified selection rules"
-- 
-- All conversions completed manually following PostgreSQL best practices:
-- - Stored procedures converted to functions or inline SQL
-- - SQL Server functions mapped to PostgreSQL equivalents
-- - Schema notation preserved as bobsbookstore_dbo
-- - Parameter syntax converted from @param to $N notation
-- - Column identifiers prepared for case-sensitive PostgreSQL (double quotes)
-- 
-- Next Step: Validate all statement pairs using SQL Equivalency MCP tool
-- ============================================================================
