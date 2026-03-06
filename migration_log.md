# Migration Log: SQL Server to PostgreSQL

## Migration Summary
- **Source Database**: BobsUsedBookStore (SQL Server 2019)
- **Target Database**: PostgreSQL 13
- **DMS Migration Project**: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- **Migration Date**: 2026-03-06
- **Total SQL Statements**: 5
- **DMS Successful Conversions**: 5
- **DMS Failed Conversions**: 0

## Schema Mapping
- **Source Schema**: `dbo`
- **Target Schema**: `bobsusedbookstore_dbo` (as determined by DMS)
- **Note**: The existing codebase used `bobsbookstore_dbo` as the schema prefix. DMS returns `bobsusedbookstore_dbo` based on the actual source database name `BobsUsedBookStore`. Per migration rules, DMS-provided schema names must be used exactly as returned.

## Statement-by-Statement Conversion Log

### Statement 1: uspUpdateAuthorPersonalInfo
- **Source File**: AuthorsController.cs, Line ~163
- **Method**: EditUsingStoredProcedure
- **Original MS SQL**: `EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;`
- **DMS Output**: `CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **DMS Status**: SUCCESS
- **DMS Timestamp**: 2026-03-06T20:38:14
- **Equivalency Status**: ERROR (tool returned error: 'uniqueID')

### Statement 2: Select All Authors
- **Source File**: AuthorsController.cs, Line ~187
- **Method**: FindAllAuthorsEmbeddedSql
- **Original MS SQL**: `SELECT * FROM dbo.Author`
- **DMS Output**: `SELECT * FROM bobsusedbookstore_dbo.author;`
- **DMS Status**: SUCCESS
- **DMS Timestamp**: 2026-03-06T20:39:46
- **Equivalency Status**: ERROR (tool returned error: 'uniqueID')

### Statement 3: uspDeleteAuthor
- **Source File**: AuthorsController.cs, Line ~208
- **Method**: DeleteAuthorEmbeddedSql
- **Original MS SQL**: `EXEC dbo.uspDeleteAuthor @BusinessEntityID;`
- **DMS Output**: `CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **DMS Status**: SUCCESS
- **DMS Timestamp**: 2026-03-06T20:41:15
- **Equivalency Status**: ERROR (tool returned error: 'uniqueID')

### Statement 4: Select Authors by Hire Year
- **Source File**: AuthorsController.cs, Line ~228
- **Method**: SelectAuthorsByHireYear
- **Original MS SQL**: `SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE DATEPART(YEAR, HireDate) = @HireDate;`
- **DMS Output**: `SELECT businessentityid, aws_sqlserver_ext.conv_datetime_to_string('VARCHAR(19)', 'DATETIME', modifieddate, 120) AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', birthdate::TIMESTAMP, clock_timestamp()::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate::TIMESTAMP) = @HireDate;`
- **DMS Status**: SUCCESS
- **DMS Timestamp**: 2026-03-06T20:42:48
- **Equivalency Status**: ERROR (tool returned error: 'uniqueID')

### Statement 5: Get Product Data
- **Source File**: ProductsController.cs, Line ~34
- **Method**: FindAllProducts
- **Original MS SQL**: `SELECT * FROM dbo.uspGetProductData();`
- **DMS Output**: `SELECT * FROM bobsusedbookstore_dbo.uspgetproductdata();`
- **DMS Status**: SUCCESS
- **DMS Timestamp**: 2026-03-06T20:44:08
- **Equivalency Status**: ERROR (tool returned error: 'uniqueID')

## Equivalency Validation Notes
All 5 statement pairs were submitted to the SQL Equivalency MCP tool (sql-equivalency___validate_sql_equivalence). All returned ERROR status with error message `'uniqueID'`. This appears to be a consistent error from the equivalency validation service. Per migration rules, these are documented as ERROR status and should be reviewed manually.

## Key DMS Conversion Observations
1. DMS correctly converts `EXEC` stored procedure calls to PostgreSQL `CALL` syntax
2. DMS correctly lowercases all schema object names (tables, procedures, columns)
3. DMS uses `bobsusedbookstore_dbo` as the target schema (from source database name BobsUsedBookStore + schema dbo)
4. DMS converts `CONVERT()` to `aws_sqlserver_ext.conv_datetime_to_string()`
5. DMS converts `DATEDIFF()` to `aws_sqlserver_ext.datediff()`
6. DMS converts `DATEPART()` to `date_part()`
7. DMS converts `GETDATE()` to `clock_timestamp()`
