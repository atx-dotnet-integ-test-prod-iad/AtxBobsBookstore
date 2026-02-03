-- ========================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Total Statements: 5
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- All DMS conversions failed with: "Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}"
-- ========================================

-- ========================================
-- Statement 1 of 5
-- Method: EditUsingStoredProcedure
-- DMS Status: ERROR
-- ========================================

-- Original SQL Server Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Converted PostgreSQL Statement:
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender) AS rows_affected;

-- Conversion Notes:
-- - SQL Server stored procedures with EXEC and return values are converted to PostgreSQL function calls
-- - Schema name preserved as bobsbookstore_dbo
-- - Function name converted to lowercase following PostgreSQL conventions
-- - Return value captured directly in SELECT statement
-- - Parameters remain named parameters

-- ========================================
-- Statement 2 of 5
-- Method: FindAllAuthorsEmbeddedSql
-- DMS Status: ERROR
-- ========================================

-- Original SQL Server Statement:
SELECT * FROM bobsbookstore_dbo.author

-- Converted PostgreSQL Statement:
SELECT * FROM bobsbookstore_dbo.author

-- Conversion Notes:
-- - This statement is already PostgreSQL compatible
-- - Schema-qualified table name preserved
-- - No changes needed but processed through conversion for consistency

-- ========================================
-- Statement 3 of 5
-- Method: DeleteAuthorEmbeddedSql
-- DMS Status: ERROR
-- ========================================

-- Original SQL Server Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Converted PostgreSQL Statement:
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID) AS rows_affected;

-- Conversion Notes:
-- - SQL Server stored procedure call converted to PostgreSQL function call
-- - Schema name preserved as bobsbookstore_dbo
-- - Function name converted to lowercase
-- - Return value captured in SELECT statement

-- ========================================
-- Statement 4 of 5
-- Method: SelectAuthorsByHireYear
-- DMS Status: ERROR
-- ========================================

-- Original SQL Server Statement:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Converted PostgreSQL Statement:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.Author WHERE DATE_PART('year', HireDate) = @HireDate;

-- Conversion Notes:
-- - FORMAT() replaced with TO_CHAR() with PostgreSQL format patterns
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) replaced with DATE_PART('year', AGE(CURRENT_DATE, BirthDate))
-- - GETDATE() replaced with CURRENT_DATE
-- - DATEPART(YEAR, HireDate) replaced with DATE_PART('year', HireDate)
-- - Table name qualified with schema: bobsbookstore_dbo.Author
-- - Format pattern changed from 'yyyy-MM-dd HH:mm:ss' to 'YYYY-MM-DD HH24:MI:SS'

-- ========================================
-- Statement 5 of 5
-- Method: FindAllProducts
-- DMS Status: ERROR
-- ========================================

-- Original SQL Server Statement:
EXEC [dbo].[uspGetProductData];

-- Converted PostgreSQL Statement:
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- Conversion Notes:
-- - SQL Server stored procedure EXEC converted to PostgreSQL function call in SELECT
-- - Schema name preserved as bobsbookstore_dbo
-- - Function name converted to lowercase
-- - Assuming function returns a table/result set

-- ========================================
-- END OF CONVERTED STATEMENTS
-- ========================================
