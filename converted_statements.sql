-- Converted SQL Statements for PostgreSQL
-- Target: PostgreSQL
-- Conversion Date: 2026-03-21
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all statements)
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.
-- DMS Timestamps: Statement 1: 2026-03-21T07:25:23, Statement 2: 2026-03-21T07:25:46, Statement 3: 2026-03-21T07:26:09, Statement 4: 2026-03-21T07:26:32, Statement 5: 2026-03-21T07:26:55

-- ============================================================
-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method (line 163)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-21T07:25:23.297979
-- Manual Conversion: EXEC stored_proc → SELECT function(); schema objects → lowercase
-- ============================================================
SELECT uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================
-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method (line 187)
-- Original: SELECT * FROM Author
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-21T07:25:46.790165
-- Manual Conversion: Table name Author → author (lowercase)
-- ============================================================
SELECT * FROM author

-- ============================================================
-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method (line 208)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-21T07:26:09.107008
-- Manual Conversion: EXEC stored_proc → SELECT function(); schema objects → lowercase
-- ============================================================
SELECT uspdeleteauthor(@BusinessEntityID);

-- ============================================================
-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method (line 228)
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-21T07:26:32.432669
-- Manual Conversion: FORMAT→TO_CHAR, DATEDIFF→EXTRACT subtraction, GETDATE()→CURRENT_DATE, DATEPART→EXTRACT; all schema objects → lowercase
-- ============================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================
-- Statement 5: ProductsController.cs - FindAllProducts method (line 34)
-- Original: EXEC [dbo].[uspGetProductData];
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- DMS Timestamp: 2026-03-21T07:26:55.228298
-- Manual Conversion: EXEC stored_proc → SELECT * FROM function(); schema objects → lowercase
-- ============================================================
SELECT * FROM uspgetproductdata();
