-- ============================================================================
-- Converted SQL Statements for PostgreSQL
-- Source: BobsBookstore Web Application
-- Total Statements: 5
-- Conversion Tool: AWS DMS MCP Statement Conversion Tool
-- Migration Project: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- Target Schema: bobsusedbookstore_dbo
-- ============================================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method
-- DMS Status: SUCCESS (converted EXEC portion; DECLARE/SELECT wrapper not needed for PostgreSQL CALL)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Note: DMS failed on full composite statement ("Statement definition is not valid"), succeeded on EXEC portion
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method
-- DMS Status: SUCCESS
-- Original: SELECT * FROM Author
SELECT * FROM bobsusedbookstore_dbo.author;

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method
-- DMS Status: SUCCESS (converted EXEC portion; DECLARE/SELECT wrapper not needed for PostgreSQL CALL)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Note: DMS failed on full composite statement ("Statement definition is not valid"), succeeded on EXEC portion
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method
-- DMS Status: SUCCESS (used GenAI-assisted conversion)
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
SELECT businessentityid, to_char(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts method
-- DMS Status: SUCCESS
-- Original: EXEC [dbo].[uspGetProductData];
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
