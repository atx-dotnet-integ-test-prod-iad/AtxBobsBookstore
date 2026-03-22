-- ============================================================
-- Converted SQL Statements - PostgreSQL Equivalents
-- BobsBookstore SQL Server to PostgreSQL Migration
-- ============================================================
-- Total Statements: 5
-- DMS Successful: 3 (Statements 2, 4, 5)
-- DMS Failed (Manual Conversion): 2 (Statements 1, 3)
-- ============================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: Statement definition is not valid.
-- DMS was called with database_name=BobsUsedBookStore, schema_name=dbo, migration_project_identifier=arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- Manual conversion: DECLARE/EXEC pattern converted to PostgreSQL function call with lowercase schema
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
SELECT bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- Conversion Method: DMS_TOOL
-- DMS Output: Success - converted_sql: SELECT * FROM bobsusedbookstore_dbo.author;
-- DMS was called with database_name=BobsUsedBookStore, schema_name=dbo, migration_project_identifier=arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- Original: SELECT * FROM Author
SELECT * FROM bobsusedbookstore_dbo.author;

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: Statement definition is not valid.
-- DMS was called with database_name=BobsUsedBookStore, schema_name=dbo, migration_project_identifier=arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- Manual conversion: DECLARE/EXEC pattern converted to PostgreSQL function call with lowercase schema
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
SELECT bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
-- Conversion Method: DMS_TOOL
-- DMS Output: Success - Used GenAI-assisted conversion
-- DMS was called with database_name=BobsUsedBookStore, schema_name=dbo, migration_project_identifier=arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- DMS converted @HireDate parameter to HireDate (bare). Restoring @HireDate for parameterized query usage in C#.
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
SELECT businessentityid, to_char(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs)
-- Conversion Method: DMS_TOOL
-- DMS Output: Success - converted_sql: CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
-- DMS was called with database_name=BobsUsedBookStore, schema_name=dbo, migration_project_identifier=arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- Original: EXEC [dbo].[uspGetProductData];
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
