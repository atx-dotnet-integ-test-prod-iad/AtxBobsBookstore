-- ============================================================================
-- Converted SQL Statements - PostgreSQL Equivalents
-- Source: BobsBookstore Application
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure method (AuthorsController.cs)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Converted: EXEC stored procedure pattern → SELECT from function call pattern
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql method (AuthorsController.cs)
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- Converted: Already lowercase and compatible, no changes needed
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql method (AuthorsController.cs)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Converted: EXEC stored procedure pattern → SELECT from function call pattern
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear method (AuthorsController.cs)
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Converted: FORMAT→TO_CHAR, DATEDIFF→EXTRACT, GETDATE()→CURRENT_TIMESTAMP, DATEPART→EXTRACT, column names to lowercase
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM CURRENT_TIMESTAMP)::INT - EXTRACT(YEAR FROM birthdate)::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts method (ProductsController.cs)
-- Original: EXEC [dbo].[uspGetProductData];
-- Converted: EXEC stored procedure → SELECT from function call
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
