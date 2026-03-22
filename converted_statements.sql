-- ============================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Date: 2026-03-22
-- ============================================================
-- DMS Tool Status: ALL 5 statements FAILED DMS conversion
-- DMS Error: Metadata model creation failed: No objects were found
--            according to the specified selection rules.
--            Please review your selection rules and try again.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================

-- Statement 1: AuthorsController.cs - FindAllAuthorsEmbeddedSql()
-- DMS Input: SELECT * FROM Author
-- DMS Status: FAILED (Metadata model creation failed)
-- DMS Timestamp: 2026-03-22T12:59:10.609146
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Manual Conversion Notes: Table name lowercased, schema mapped to bobsbookstore_dbo
-- Original MS SQL:
--   SELECT * FROM [dbo].[Author]
-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.author

-- Statement 2: AuthorsController.cs - SelectAuthorsByHireYear()
-- DMS Input: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Status: FAILED (Metadata model creation failed)
-- DMS Timestamp: 2026-03-22T12:59:26.046972
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Manual Conversion Notes:
--   - FORMAT() -> TO_CHAR() with PostgreSQL format string
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) -> DATE_PART('year', AGE(NOW(), birthdate))::int
--   - DATEPART(YEAR, HireDate) -> DATE_PART('year', hiredate)
--   - Column names lowercased, schema mapped to bobsbookstore_dbo
-- Original MS SQL:
--   SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Converted PostgreSQL:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(NOW(), birthdate))::int AS age FROM bobsbookstore_dbo.author WHERE DATE_PART('year', hiredate) = @HireDate;

-- Statement 3: AuthorsController.cs - EditUsingStoredProcedure()
-- DMS Input: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: FAILED (Metadata model creation failed)
-- DMS Timestamp: 2026-03-22T12:59:53.307530
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Manual Conversion Notes:
--   - T-SQL DECLARE/EXEC/SELECT pattern converted to PostgreSQL SELECT function() call
--   - [dbo].[uspUpdateAuthorPersonalInfo] -> bobsbookstore_dbo.uspupdateauthorpersonalinfo (lowercase)
--   - Parameters passed as function arguments
-- Original MS SQL:
--   DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Converted PostgreSQL:
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 4: AuthorsController.cs - DeleteAuthorEmbeddedSql()
-- DMS Input: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: FAILED (Metadata model creation failed)
-- DMS Timestamp: 2026-03-22T13:00:08.705068
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Manual Conversion Notes:
--   - T-SQL DECLARE/EXEC/SELECT pattern converted to PostgreSQL SELECT function() call
--   - [dbo].[uspDeleteAuthor] -> bobsbookstore_dbo.uspdeleteauthor (lowercase)
--   - Parameter passed as function argument
-- Original MS SQL:
--   DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Converted PostgreSQL:
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 5: ProductsController.cs - FindAllProducts()
-- DMS Input: EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED (Metadata model creation failed)
-- DMS Timestamp: 2026-03-22T13:00:24.179821
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Manual Conversion Notes:
--   - T-SQL EXEC converted to PostgreSQL SELECT * FROM function() call
--   - [dbo].[uspGetProductData] -> bobsbookstore_dbo.uspgetproductdata (lowercase)
-- Original MS SQL:
--   EXEC [dbo].[uspGetProductData];
-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
