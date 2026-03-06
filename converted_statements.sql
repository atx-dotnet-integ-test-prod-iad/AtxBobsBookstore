-- ============================================================================
-- Converted SQL Statements for BobsBookstore Application
-- Target: PostgreSQL
-- Conversion Date: 2026-03-06
-- Tool: AWS DMS MCP Statement Conversion Tool
-- Re-validation Pass: 2026-03-06 (DMS metadata model creation failed for all 5)
-- ============================================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status (initial pass): Compound statement failed; EXEC portion converted successfully
-- DMS Status (re-validation pass): ERROR - Metadata model creation failed: The selected objects were not found.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (re-validation pass DMS failure; retained previous DMS output)
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- DMS Status (initial pass): SUCCESS
-- DMS Status (re-validation pass): ERROR - Metadata model creation failed: The selected objects were not found.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (re-validation pass DMS failure; retained previous DMS output)
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status (initial pass): Compound statement failed; EXEC portion converted successfully
-- DMS Status (re-validation pass): ERROR - Metadata model creation failed: The selected objects were not found.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (re-validation pass DMS failure; retained previous DMS output)
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Status (initial pass): SUCCESS (GenAI assisted)
-- DMS Status (re-validation pass): ERROR - Metadata model creation failed: The selected objects were not found.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (re-validation pass DMS failure; retained previous DMS output with corrections)
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Note: Previous DMS output used aws_sqlserver_ext.datediff. Replaced with standard PostgreSQL EXTRACT(YEAR FROM AGE(...)).
--       DMS also dropped @HireDate parameter and schema prefix. Corrected to retain both.
SELECT businessentityid, to_char(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts
-- Original: EXEC [dbo].[uspGetProductData];
-- DMS Status (initial pass): SUCCESS
-- DMS Status (re-validation pass): ERROR - Metadata model creation failed: The selected objects were not found.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (re-validation pass DMS failure; retained previous DMS output)
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
