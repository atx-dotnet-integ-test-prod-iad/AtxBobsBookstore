-- ============================================================================
-- Converted SQL Statements - PostgreSQL Target
-- Source: BobsBookstore .NET ADO Application
-- Conversion Date: 2026-03-23
-- Total Statements: 5
-- Conversion Tool: AWS DMS MCP Tool (with manual fallback for 2 statements)
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line 165)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: "Statement definition is not valid" (stored procedure EXEC wrapper not supported)
-- Resolution: DMS successfully converted the underlying UPDATE operation; replaced stored procedure call with direct UPDATE
UPDATE bobsusedbookstore_dbo.author SET nationalidnumber = @NationalIDNumber, birthdate = @BirthDate, maritalstatus = @MaritalStatus, gender = @Gender WHERE businessentityid = @BusinessEntityID;

-- Statement 2: FindAllAuthorsEmbeddedSql (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line 189)
-- Conversion Method: DMS_TOOL
-- DMS kept the statement as-is (already PostgreSQL compatible)
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 3: DeleteAuthorEmbeddedSql (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line 212)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: "Statement definition is not valid" (stored procedure EXEC wrapper not supported)
-- Resolution: DMS successfully converted the underlying DELETE operation; replaced stored procedure call with direct DELETE
DELETE FROM bobsusedbookstore_dbo.author WHERE businessentityid = @BusinessEntityID;

-- Statement 4: SelectAuthorsByHireYear (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line 232)
-- Conversion Method: DMS_TOOL
-- Note: Original MS SQL equivalent used: SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;
SELECT businessentityid, aws_sqlserver_ext.conv_datetime_to_string('VARCHAR', 'DATETIME', modifieddate, 120) AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', birthdate::TIMESTAMP, clock_timestamp()::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;

-- Statement 5: FindAllProducts (Converted)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs (line 36)
-- Conversion Method: DMS_TOOL
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
