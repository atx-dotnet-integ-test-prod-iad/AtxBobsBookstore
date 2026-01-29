-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration for Bob's Bookstore
-- ============================================================================
-- Purpose: PostgreSQL equivalents of all extracted SQL statements
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- Date: 2026-01-29
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Edit Author Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR (Metadata model creation failed)
-- 
-- Original T-SQL:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;
--
-- Converted PostgreSQL (Function Call):
SELECT bobsbookstore_dbo.update_author_personal_info(
    @BusinessEntityID, 
    @NationalIDNumber, 
    @BirthDate, 
    @MaritalStatus, 
    @Gender
) AS rows_affected;

-- Alternative Inline SQL (if function not available):
-- WITH update_result AS (
--     UPDATE bobsbookstore_dbo.author
--     SET 
--         "NationalIDNumber" = @NationalIDNumber,
--         "BirthDate" = @BirthDate,
--         "MaritalStatus" = @MaritalStatus,
--         "Gender" = @Gender,
--         "ModifiedDate" = NOW()
--     WHERE "BusinessEntityID" = @BusinessEntityID
--     RETURNING 1
-- )
-- SELECT COUNT(*) AS rows_affected FROM update_result;

-- ============================================================================
-- STATEMENT 2: Find All Authors
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR (Metadata model creation failed)
-- 
-- Original T-SQL:
-- SELECT * FROM bobsbookstore_dbo.author
--
-- Converted PostgreSQL (No changes needed - already compatible):
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR (Metadata model creation failed)
-- 
-- Original T-SQL:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;
--
-- Converted PostgreSQL (Function Call):
SELECT bobsbookstore_dbo.delete_author(@BusinessEntityID) AS rows_affected;

-- Alternative Inline SQL (if function not available):
-- WITH delete_result AS (
--     DELETE FROM bobsbookstore_dbo.author
--     WHERE "BusinessEntityID" = @BusinessEntityID
--     RETURNING 1
-- )
-- SELECT COUNT(*) AS rows_affected FROM delete_result;

-- ============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Date Functions
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR (Metadata model creation failed)
-- 
-- Original T-SQL:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
--        DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
-- FROM bobsbookstore_dbo.author 
-- WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- Converted PostgreSQL:
SELECT 
    "BusinessEntityID", 
    TO_CHAR("ModifiedDate", 'YYYY-MM-DD HH24:MI:SS') AS "FormattedModifiedDate", 
    DATE_PART('year', AGE(NOW(), "BirthDate"))::INTEGER AS "Age" 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM "HireDate") = @HireDate;

-- T-SQL to PostgreSQL Function Conversions:
-- FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') -> TO_CHAR("ModifiedDate", 'YYYY-MM-DD HH24:MI:SS')
-- DATEDIFF(YEAR, BirthDate, GETDATE()) -> DATE_PART('year', AGE(NOW(), "BirthDate"))::INTEGER
-- GETDATE() -> NOW()
-- DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM "HireDate")

-- ============================================================================
-- STATEMENT 5: Get Product Data Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR (Metadata model creation failed)
-- 
-- Original T-SQL:
-- EXEC [dbo].[uspGetProductData];
--
-- Converted PostgreSQL (Function Call):
SELECT * FROM bobsbookstore_dbo.get_product_data();

-- Alternative Simple SELECT (if stored procedure just returns product data):
-- SELECT * FROM bobsbookstore_dbo.product;

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total Statements Converted: 5
-- DMS Tool Success: 0
-- Manual Conversions: 5 (100%)
-- 
-- Conversion Status by Statement:
-- 1. Statement 1 (Edit Author): MANUAL - Stored procedure to function call
-- 2. Statement 2 (Find All Authors): MANUAL - No changes needed (already compatible)
-- 3. Statement 3 (Delete Author): MANUAL - Stored procedure to function call
-- 4. Statement 4 (Select by Hire Year): MANUAL - T-SQL functions to PostgreSQL
-- 5. Statement 5 (Get Products): MANUAL - Stored procedure to function call
-- 
-- All conversions required manual intervention due to DMS metadata model issues.
-- All T-SQL specific syntax has been converted to PostgreSQL equivalents.
-- Stored procedure calls converted to function calls (assumes procedures migrated).
-- 
-- ============================================================================
-- END OF CONVERTED STATEMENTS CATALOG
-- ============================================================================
