-- ============================================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application (SQL Server to PostgreSQL Migration)
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5)
-- DMS Error: Metadata model creation failed - No objects found according to selection rules
-- ============================================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion: Stored procedure call converted to PostgreSQL function call with lowercase schema
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method
-- Original: SELECT * FROM Author
-- Conversion: Table name converted to lowercase with schema qualification
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion: Stored procedure call converted to PostgreSQL function call with lowercase schema
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Conversion: T-SQL functions converted to PostgreSQL equivalents, lowercase schema/columns
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts method
-- Original: EXEC [dbo].[uspGetProductData];
-- Conversion: Stored procedure call converted to PostgreSQL function call with lowercase schema
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
