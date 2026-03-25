-- ============================================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Date: 2026-03-25
-- Last Updated: 2026-03-25 (Step 1 - DMS re-attempt #2)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: Metadata model creation failed - No objects found according to selection rules
-- DMS Attempt #1 Timestamps: 2026-03-25T01:14:26, 2026-03-25T01:14:48, 2026-03-25T01:15:10,
--                             2026-03-25T01:15:32, 2026-03-25T01:15:54
-- DMS Attempt #2 Timestamps: 2026-03-25T01:44:50, 2026-03-25T01:45:14, 2026-03-25T01:45:35,
--                             2026-03-25T01:45:58, 2026-03-25T01:46:21
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs ~line 165)
-- Original: EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- DMS Status: FAILED (Attempt #1: 2026-03-25T01:14:26, Attempt #2: 2026-03-25T01:44:50 - Metadata model creation failed)
-- Conversion: Stored procedure replaced with direct UPDATE statement using lowercase schema objects
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
UPDATE bobsbookstore_dbo.author SET nationalidnumber = @NationalIDNumber, birthdate = @BirthDate, maritalstatus = @MaritalStatus, gender = @Gender WHERE businessentityid = @BusinessEntityID;

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs ~line 192)
-- Original: SELECT * FROM [dbo].[Author]
-- DMS Status: FAILED (Attempt #1: 2026-03-25T01:14:48, Attempt #2: 2026-03-25T01:45:14 - Metadata model creation failed)
-- Conversion: Table name converted to lowercase with bobsbookstore_dbo schema
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs ~line 207)
-- Original: EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- DMS Status: FAILED (Attempt #1: 2026-03-25T01:15:10, Attempt #2: 2026-03-25T01:45:35 - Metadata model creation failed)
-- Conversion: Stored procedure replaced with direct DELETE statement using lowercase schema objects
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
DELETE FROM bobsbookstore_dbo.author WHERE businessentityid = @BusinessEntityID;

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs ~line 229)
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Status: FAILED (Attempt #1: 2026-03-25T01:15:32, Attempt #2: 2026-03-25T01:45:58 - Metadata model creation failed)
-- Conversion: FORMAT()->TO_CHAR(), DATEDIFF()->EXTRACT(YEAR FROM AGE()), GETDATE()->NOW(), DATEPART()->EXTRACT(), lowercase schema objects
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs ~line 36)
-- Original: EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED (Attempt #1: 2026-03-25T01:15:54, Attempt #2: 2026-03-25T01:46:21 - Metadata model creation failed)
-- Conversion: Stored procedure replaced with direct SELECT statement using lowercase schema objects
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
SELECT productid, name, productnumber, safetystocklevel FROM bobsbookstore_dbo.product;
