-- ============================================================
-- CONVERTED SQL STATEMENTS CATALOG (PostgreSQL)
-- Source: BobsBookstore .NET ADO Application
-- Date: 2026-03-27
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5)
-- DMS Error: Metadata model creation failed - No objects found
--            according to specified selection rules
-- ============================================================

-- ============================================================
-- Statement 1: FindAllAuthorsEmbeddedSql (PostgreSQL)
-- Original: SELECT * FROM Author
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Output: error - Metadata model creation failed: No objects were found
-- Manual Conversion: Applied lowercase schema (bobsbookstore_dbo) and lowercase table name (author)
-- ============================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================
-- Statement 2: EditUsingStoredProcedure (PostgreSQL)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Output: error - Metadata model creation failed: No objects were found
-- Manual Conversion: Converted SQL Server DECLARE/EXEC pattern to PostgreSQL function call syntax with lowercase schema
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql (PostgreSQL)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Output: error - Metadata model creation failed: No objects were found
-- Manual Conversion: Converted SQL Server DECLARE/EXEC pattern to PostgreSQL function call syntax with lowercase schema
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear (PostgreSQL)
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Output: error - Metadata model creation failed: No objects were found
-- Manual Conversion: Converted FORMAT->TO_CHAR, DATEDIFF->DATE_PART+AGE, DATEPART->DATE_PART, GETDATE()->CURRENT_DATE, applied lowercase columns/aliases/schema
-- ============================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(birthdate)) AS age FROM bobsbookstore_dbo.author WHERE DATE_PART('year', hiredate) = @HireDate;

-- ============================================================
-- Statement 5: FindAllProducts (PostgreSQL)
-- Original: EXEC [dbo].[uspGetProductData];
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Output: error - Metadata model creation failed: No objects were found
-- Manual Conversion: Converted SQL Server EXEC to PostgreSQL function call syntax with lowercase schema
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
