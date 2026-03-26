# DMS Conversion Summary Report
## Date: 2026-03-26 (Updated with 3rd Re-attempt Results)

All 5 SQL statements were submitted to the DMS MCP tool (dms-mcp___statement_conversion_tool) on three separate occasions. All three attempts for all 5 statements failed with the same metadata model creation error. Manual conversion was applied with lowercase schema object names per the DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA convention.

## DMS Tool Configuration
- **Migration Project ARN**: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- **Database Name**: BobsBookstore
- **Schema Name**: dbo
- **Server Name**: 172.31.82.226
- **Region**: us-east-1

## DMS Error Details
- **Error**: Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.
- **Error Stage**: create_metadata_model
- **Consistent across all 5 statements**: YES
- **First Attempt Timestamps**: 2026-03-26T20:23:35 through 2026-03-26T20:25:18
- **Second Attempt Timestamps**: 2026-03-26T20:48:55 through 2026-03-26T20:50:06
- **Third Attempt Timestamps**: 2026-03-26T21:20:41 through 2026-03-26T21:22:30

## DMS Attempts Summary

| Statement # | Statement Name | 1st Attempt Timestamp | 1st Result | 2nd Attempt Timestamp | 2nd Result | 3rd Attempt Timestamp | 3rd Result |
|---|---|---|---|---|---|---|---|
| 1 | EditUsingStoredProcedure | 2026-03-26T20:23:35 | ERROR | 2026-03-26T20:48:55 | ERROR | 2026-03-26T21:20:41 | ERROR |
| 2 | FindAllAuthorsEmbeddedSql | 2026-03-26T20:24:02 | ERROR | 2026-03-26T20:49:09 | ERROR | 2026-03-26T21:21:04 | ERROR |
| 3 | DeleteAuthorEmbeddedSql | 2026-03-26T20:24:26 | ERROR | 2026-03-26T20:49:24 | ERROR | 2026-03-26T21:21:28 | ERROR |
| 4 | SelectAuthorsByHireYear | 2026-03-26T20:24:54 | ERROR | 2026-03-26T20:49:38 | ERROR | 2026-03-26T21:21:53 | ERROR |
| 5 | FindAllProducts | 2026-03-26T20:25:18 | ERROR | 2026-03-26T20:49:52 | ERROR | 2026-03-26T21:22:15 | ERROR |

## Manual Conversions Applied (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)

### Statement 1: EditUsingStoredProcedure
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **DMS Output**: Error - Metadata model creation failed (all 3 attempts)
- **Manual PostgreSQL Conversion**: `SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Rationale**: SQL Server DECLARE/EXEC/SELECT pattern converted to PostgreSQL SELECT FROM function() pattern. Schema [dbo] mapped to bobsbookstore_dbo. Stored procedure name lowercased per PostgreSQL conventions.

### Statement 2: FindAllAuthorsEmbeddedSql
- **Original MS SQL**: `SELECT * FROM [dbo].[Author]`
- **DMS Output**: Error - Metadata model creation failed (all 3 attempts)
- **Manual PostgreSQL Conversion**: `SELECT * FROM bobsbookstore_dbo."author"`
- **Conversion Rationale**: Schema [dbo] mapped to bobsbookstore_dbo. Table name [Author] lowercased to "author" for PostgreSQL compatibility.

### Statement 3: DeleteAuthorEmbeddedSql
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **DMS Output**: Error - Metadata model creation failed (all 3 attempts)
- **Manual PostgreSQL Conversion**: `SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Conversion Rationale**: SQL Server DECLARE/EXEC/SELECT pattern converted to PostgreSQL SELECT FROM function() pattern. Schema [dbo] mapped to bobsbookstore_dbo. Stored procedure name lowercased.

### Statement 4: SelectAuthorsByHireYear
- **Original MS SQL**: `SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;`
- **DMS Output**: Error - Metadata model creation failed (all 3 attempts)
- **Manual PostgreSQL Conversion**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, birthdate))::integer AS age FROM bobsbookstore_dbo."author" WHERE DATE_PART('year', hiredate) = @HireDate;`
- **Conversion Rationale**: 
  - CONVERT(VARCHAR, ModifiedDate, 120) → TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') (style 120 = ODBC canonical yyyy-mm-dd hh:mi:ss)
  - DATEDIFF(YEAR, BirthDate, GETDATE()) → DATE_PART('year', AGE(CURRENT_TIMESTAMP, birthdate))::integer
  - YEAR(HireDate) → DATE_PART('year', hiredate)
  - Column names lowercased, table name lowercased, schema [dbo] mapped to bobsbookstore_dbo

### Statement 5: FindAllProducts
- **Original MS SQL**: `EXEC [dbo].[uspGetProductData];`
- **DMS Output**: Error - Metadata model creation failed (all 3 attempts)
- **Manual PostgreSQL Conversion**: `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Conversion Rationale**: SQL Server EXEC converted to PostgreSQL SELECT FROM function() pattern. Schema [dbo] mapped to bobsbookstore_dbo. Stored procedure name lowercased.
