-- Extracted MS SQL Statements from BobsBookstore Application
-- ============================================================
-- Date: 2026-03-06
-- Total statements: 5
-- Source files: AuthorsController.cs (4 statements), ProductsController.cs (1 statement)
-- DMS Conversion Attempts: All 5 statements passed through DMS MCP tool (dms-mcp___statement_conversion_tool)
-- DMS Result: All 5 failed with "Metadata model creation failed: The selected objects were not found."
-- DMS Parameters Used: migration_project_identifier='arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U',
--                       database_name='BobsBookstore', schema_name='dbo', region='us-east-1'

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure (line ~163)
-- Source file: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Description: Calls dbo.uspUpdateAuthorPersonalInfo stored procedure with 5 parameters
-- DMS Attempt Timestamp: 2026-03-06T01:09:58.908921
-- DMS Status: error - Metadata model creation failed: The selected objects were not found.
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql (line ~187)
-- Source file: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Description: Simple SELECT to retrieve all authors
-- DMS Attempt Timestamp: 2026-03-06T01:10:24.289591
-- DMS Status: error - Metadata model creation failed: The selected objects were not found.
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql (line ~208)
-- Source file: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Description: Calls dbo.uspDeleteAuthor stored procedure with 1 parameter
-- DMS Attempt Timestamp: 2026-03-06T01:10:47.870967
-- DMS Status: error - Metadata model creation failed: The selected objects were not found.
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear (line ~228)
-- Source file: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Description: Complex SELECT with date functions and filtering
-- DMS Attempt Timestamp: 2026-03-06T01:11:12.576888
-- DMS Status: error - Metadata model creation failed: The selected objects were not found.
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts (line ~34)
-- Source file: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Description: Calls dbo.uspGetProductData stored procedure
-- DMS Attempt Timestamp: 2026-03-06T01:11:37.000066
-- DMS Status: error - Metadata model creation failed: The selected objects were not found.
EXEC [dbo].[uspGetProductData];
