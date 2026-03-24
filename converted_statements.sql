-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application  
-- Conversion: SQL Server -> PostgreSQL
-- DMS Status: All 5 statements failed DMS conversion (Metadata model creation failed)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- ============================================================================
-- Statement 1 - EditUsingStoredProcedure (AuthorsController.cs)
-- ============================================================================
-- ORIGINAL (MS SQL):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
--
-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 2 - FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- ============================================================================
-- ORIGINAL (MS SQL):
-- SELECT * FROM bobsbookstore_dbo.author
--
-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- Statement 3 - DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- ============================================================================
-- ORIGINAL (MS SQL):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
--
-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4 - SelectAuthorsByHireYear (AuthorsController.cs)
-- ============================================================================
-- ORIGINAL (MS SQL):
-- SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
--
-- CONVERTED (PostgreSQL):
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================================
-- Statement 5 - FindAllProducts (ProductsController.cs)
-- ============================================================================
-- ORIGINAL (MS SQL):
-- EXEC [dbo].[uspGetProductData];
--
-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================================
-- Total Statements Converted: 5
-- DMS Successful Conversions: 0
-- Manual Conversions (DMS Failure): 5
-- ============================================================================
