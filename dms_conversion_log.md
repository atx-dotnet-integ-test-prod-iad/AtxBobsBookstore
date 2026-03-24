# DMS Conversion Log

## Migration: Microsoft SQL Server to PostgreSQL
## Application: BobsBookstore .NET Application
## Date: 2026-03-24
## DMS Migration Project ARN: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U

---

## Summary

All 5 SQL statements were submitted to the DMS MCP tool for conversion across 3 attempts (initial + 2 retries). Parameters used:
- `database_name`: BobsBookstore
- `schema_name`: dbo
- `migration_project_identifier`: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- `region`: us-east-1
- `server_name`: 172.31.82.226 (auto-detected)

All 5 failed consistently across all attempts with the same error:
`Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.`

All statements were manually converted applying lowercase schema object naming conventions for PostgreSQL compatibility, documented with reason `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`.

### Latest Retry Timestamps (Attempt 3 - 2026-03-24T17:02-17:04)
- Statement 1: 2026-03-24T17:02:38.556069
- Statement 2: 2026-03-24T17:03:02.517547
- Statement 3: 2026-03-24T17:03:25.991930
- Statement 4: 2026-03-24T17:03:49.349243
- Statement 5: 2026-03-24T17:04:11.836419

---

## Statement 1: FindAllAuthorsEmbeddedSql

- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs (FindAllAuthorsEmbeddedSql method)
- **Original MS SQL**: `SELECT * FROM Author`
- **DMS Input Parameters**: database_name=BobsBookstore, schema_name=dbo, server_name=172.31.82.226
- **DMS Latest Timestamp**: 2026-03-24T17:02:38.556069
- **DMS Status**: ERROR (failed across all 3 attempts)
- **DMS Error**: `Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}`
- **Manual Conversion**: `SELECT * FROM bobsbookstore_dbo.author;`
- **Conversion Details**:
  - Table `Author` lowercased to `author`
  - Schema mapped: implicit `dbo` → explicit `bobsbookstore_dbo` (matching existing PostgreSQL schema)
- **Conversion Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

---

## Statement 2: EditUsingStoredProcedure

- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs (EditUsingStoredProcedure method)
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **DMS Input Parameters**: database_name=BobsBookstore, schema_name=dbo, server_name=172.31.82.226
- **DMS Latest Timestamp**: 2026-03-24T17:03:02.517547
- **DMS Status**: ERROR (failed across all 3 attempts)
- **DMS Error**: `Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}`
- **Manual Conversion**: `SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Details**:
  - Converted SQL Server `DECLARE @var/EXEC @var = proc/SELECT @var` pattern to PostgreSQL `SELECT function()` call
  - Schema `[dbo]` mapped to `bobsbookstore_dbo` (matching existing PostgreSQL schema)
  - Stored procedure name lowercased: `uspUpdateAuthorPersonalInfo` → `uspupdateauthorpersonalinfo`
- **Conversion Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

---

## Statement 3: DeleteAuthorEmbeddedSql

- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs (DeleteAuthorEmbeddedSql method)
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **DMS Input Parameters**: database_name=BobsBookstore, schema_name=dbo, server_name=172.31.82.226
- **DMS Latest Timestamp**: 2026-03-24T17:03:25.991930
- **DMS Status**: ERROR (failed across all 3 attempts)
- **DMS Error**: `Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}`
- **Manual Conversion**: `SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Conversion Details**:
  - Converted SQL Server `DECLARE @var/EXEC @var = proc/SELECT @var` pattern to PostgreSQL `SELECT function()` call
  - Schema `[dbo]` mapped to `bobsbookstore_dbo` (matching existing PostgreSQL schema)
  - Stored procedure name lowercased: `uspDeleteAuthor` → `uspdeleteauthor`
- **Conversion Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

---

## Statement 4: SelectAuthorsByHireYear

- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs (SelectAuthorsByHireYear method)
- **Original MS SQL**: `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEPART(YEAR, HireDate) = @HireDate`
- **DMS Input Parameters**: database_name=BobsBookstore, schema_name=dbo, server_name=172.31.82.226
- **DMS Latest Timestamp**: 2026-03-24T17:03:49.349243
- **DMS Status**: ERROR (failed across all 3 attempts)
- **DMS Error**: `Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}`
- **Manual Conversion**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Conversion Details**:
  - `FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss')` → `TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')`
  - `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER`
  - `DATEPART(YEAR, HireDate)` → `EXTRACT(YEAR FROM hiredate)`
  - Column names lowercased: `BusinessEntityID` → `businessentityid`, `ModifiedDate` → `modifieddate`, `BirthDate` → `birthdate`, `HireDate` → `hiredate`
  - Aliases lowercased: `FormattedModifiedDate` → `formattedmodifieddate`, `Age` → `age`
  - Schema and table mapped: `[dbo].[Author]` → `bobsbookstore_dbo.author`
- **Conversion Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

---

## Statement 5: FindAllProducts

- **Source File**: app/Bookstore.Web/Controllers/ProductsController.cs (FindAllProducts method)
- **Original MS SQL**: `EXEC [dbo].[uspGetProductData];`
- **DMS Input Parameters**: database_name=BobsBookstore, schema_name=dbo, server_name=172.31.82.226
- **DMS Latest Timestamp**: 2026-03-24T17:04:11.836419
- **DMS Status**: ERROR (failed across all 3 attempts)
- **DMS Error**: `Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}`
- **Manual Conversion**: `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Conversion Details**:
  - Converted SQL Server `EXEC procedure` pattern to PostgreSQL `SELECT * FROM function()` call
  - Schema `[dbo]` mapped to `bobsbookstore_dbo` (matching existing PostgreSQL schema)
  - Stored procedure name lowercased: `uspGetProductData` → `uspgetproductdata`
  - Added `SELECT * FROM` and `()` for PostgreSQL function call syntax
- **Conversion Reason**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
