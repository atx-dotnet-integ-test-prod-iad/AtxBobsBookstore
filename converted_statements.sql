-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Conversion Date: 2026-02-13
-- Schema: bobsbookstore_dbo
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Info
-- ============================================================================
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;
--
-- DMS Tool Status: ERROR
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Notes: SQL Server stored procedure call converted to PostgreSQL function call
--        Assuming PostgreSQL function bobsbookstore_dbo.uspupdateauthorpersonalinfo exists
-- ============================================================================
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    @BusinessEntityID, 
    @NationalIDNumber, 
    @BirthDate, 
    @MaritalStatus, 
    @Gender
);

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Retrieve All Authors
-- ============================================================================
-- Original SQL Server Statement:
-- SELECT * FROM bobsbookstore_dbo.author
--
-- DMS Tool Status: ERROR
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Notes: Statement is already PostgreSQL compatible, no conversion needed
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author via Stored Procedure
-- ============================================================================
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;
--
-- DMS Tool Status: ERROR
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Notes: SQL Server stored procedure call converted to PostgreSQL function call
--        Assuming PostgreSQL function bobsbookstore_dbo.uspdeleteauthor exists
-- ============================================================================
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Select Authors with Age Calculation
-- ============================================================================
-- Original SQL Server Statement:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
--        DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
-- FROM Author 
-- WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- DMS Tool Status: ERROR
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Notes: SQL Server date functions converted to PostgreSQL equivalents:
--        FORMAT() -> TO_CHAR()
--        DATEDIFF(YEAR, date1, date2) -> EXTRACT(YEAR FROM AGE(date2, date1))
--        GETDATE() -> NOW()
--        DATEPART(YEAR, date) -> EXTRACT(YEAR FROM date)
-- ============================================================================
SELECT "BusinessEntityID", 
       TO_CHAR("ModifiedDate", 'YYYY-MM-DD HH24:MI:SS') AS "FormattedModifiedDate", 
       EXTRACT(YEAR FROM AGE(NOW(), "BirthDate")) AS "Age" 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM "HireDate") = @HireDate;

-- ============================================================================
-- STATEMENT 5: FindAllProducts - Retrieve All Products via Stored Procedure
-- ============================================================================
-- Original SQL Server Statement:
-- EXEC [dbo].[uspGetProductData];
--
-- DMS Tool Status: ERROR
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Notes: SQL Server stored procedure call converted to PostgreSQL function call
--        Assuming PostgreSQL function bobsbookstore_dbo.uspgetproductdata exists
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total SQL Statements Converted: 5
-- Successfully Converted by DMS Tool: 0
-- Manually Converted After DMS Failure: 5
-- Stored Procedure Conversions: 3
-- Date Function Conversions: 4 (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- Schema: bobsbookstore_dbo (unchanged from original)
-- ============================================================================
-- IMPORTANT NOTES:
-- 1. All stored procedure calls assume PostgreSQL functions exist in bobsbookstore_dbo schema
-- 2. Function names are lowercased per PostgreSQL convention
-- 3. DECLARE/EXEC/SELECT patterns converted to direct function calls
-- 4. Date functions converted to PostgreSQL equivalents
-- 5. Column names in STATEMENT 4 quoted to preserve case sensitivity
-- ============================================================================
