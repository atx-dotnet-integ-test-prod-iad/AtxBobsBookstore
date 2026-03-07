-- ============================================================
-- Converted PostgreSQL Statements Catalog
-- Source: DMS MCP Tool Conversion
-- Migration Project: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
-- Database: BobsUsedBookStore
-- Date: 2026-03-07
-- Total Statements: 5
-- All statements converted via DMS MCP Tool
-- ============================================================

-- Statement 1: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- DMS Model: sql-conversion-1772897775
-- DMS Conversion Timestamp: 2026-03-07T15:37:33.856954
SELECT
    *
    FROM bobsusedbookstore_dbo.author;

-- Statement 2: EditUsingStoredProcedure (AuthorsController.cs)
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- DMS Model: sql-conversion-1772897859
-- DMS Conversion Timestamp: 2026-03-07T15:38:57.442321
CALL HumanResources.uspUpdateEmployeePersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- DMS Model: sql-conversion-1772897942
-- DMS Conversion Timestamp: 2026-03-07T15:40:20.861933
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- DMS Model: sql-conversion-1772898026
-- DMS Conversion Timestamp: 2026-03-07T15:41:44.613911
SELECT
    businessentityid, CAST (ModifiedDate AS VARCHAR(30)) AS formattedmodifieddate, datediff(year, BirthDate, clock_timestamp()) AS age
    FROM HumanResources.Employee
    WHERE date_part('year', HireDate::TIMESTAMP) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs)
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- DMS Model: sql-conversion-1772898109
-- DMS Conversion Timestamp: 2026-03-07T15:43:08.332092
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
