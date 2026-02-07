-- Converted SQL Statements for PostgreSQL
-- Date: Migration from MS SQL Server to PostgreSQL
-- This file contains all PostgreSQL converted statements

-- ============================================================================
-- Statement 1: Simple SELECT from author table
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- Conversion: Schema reference format adjusted for PostgreSQL
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- Statement 2: Stored Procedure Call - Update Author Personal Info
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion: Convert to PostgreSQL function call using SELECT
-- Note: PostgreSQL functions use SELECT, not EXEC
-- The function should return the number of rows affected
-- ============================================================================
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 3: Stored Procedure Call - Delete Author
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion: Convert to PostgreSQL function call using SELECT
-- ============================================================================
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4: Complex SELECT with SQL Server Functions
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Conversions:
--   FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') → TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS')
--   DATEDIFF(YEAR, BirthDate, GETDATE()) → DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate))
--   GETDATE() → CURRENT_TIMESTAMP
--   DATEPART(YEAR, HireDate) → EXTRACT(YEAR FROM HireDate)
-- ============================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ============================================================================
-- Statement 5: Stored Procedure Execution - Get Product Data
-- Original: EXEC [dbo].[uspGetProductData];
-- Conversion: 
--   Option 1: Call as function - SELECT * FROM bobsbookstore_dbo.uspGetProductData();
--   Option 2: Direct SELECT if procedure was converted to return table
--   Using Option 2 based on stored procedure definition which returns a result set
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- ============================================================================
-- CONVERSION NOTES
-- ============================================================================
-- All statements have been manually converted after DMS tool failure
-- Key PostgreSQL conversions applied:
-- 1. EXEC stored_proc → SELECT schema.function_name(params) or SELECT * FROM schema.function_name()
-- 2. FORMAT() → TO_CHAR() with PostgreSQL date format codes
-- 3. DATEDIFF(YEAR, d1, d2) → DATE_PART('year', AGE(d2, d1))
-- 4. GETDATE() → CURRENT_TIMESTAMP
-- 5. DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
-- 6. [dbo].[name] → bobsbookstore_dbo.name (schema.object format)
-- 7. DECLARE/variable assignments removed - handled by PostgreSQL functions
-- 8. @parameter syntax preserved (Npgsql supports both @ and $ syntax)
-- ============================================================================
