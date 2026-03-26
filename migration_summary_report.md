# Migration Summary Report: SQL Server to PostgreSQL

## Overview
This report documents the complete migration of the BobsBookstore .NET ADO application from Microsoft SQL Server to PostgreSQL.

## Migration Statistics

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Successfully converted by DMS MCP tool | 0 |
| Manually converted (DMS failure) | 5 |
| Validated as EQUIVALENT by SQL Equivalency tool | 0 |
| Validated as NOT_EQUIVALENT by SQL Equivalency tool | 0 |
| Equivalency validation ERROR | 5 |

## DMS Tool Results
All 5 SQL statements were passed through the DMS MCP tool (dms-mcp___statement_conversion_tool) **twice** (original run + retry) with the following parameters:
- **migration_project_identifier**: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- **database_name**: BobsBookstore
- **schema_name**: dbo
- **region**: us-east-1
- **server_name**: 172.31.82.226

**Result**: All 5 statements failed in both attempts with the same error:
```
Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
```

### DMS Conversion Timestamps
| Statement | Original Timestamp | Retry Timestamp | Status |
|-----------|-------------------|-----------------|--------|
| Statement 1 (EditUsingStoredProcedure) | 2026-03-26T13:42:08.169705 | 2026-03-26T14:10:09.570267 | FAILED |
| Statement 2 (FindAllAuthorsEmbeddedSql) | 2026-03-26T13:42:30.704512 | 2026-03-26T14:10:37.587580 | FAILED |
| Statement 3 (DeleteAuthorEmbeddedSql) | 2026-03-26T13:42:54.709123 | 2026-03-26T14:11:00.795559 | FAILED |
| Statement 4 (SelectAuthorsByHireYear) | 2026-03-26T13:43:18.259354 | 2026-03-26T14:11:25.431236 | FAILED |
| Statement 5 (FindAllProducts) | 2026-03-26T13:43:43.484273 | 2026-03-26T14:11:47.818763 | FAILED |

## Manual Conversion Applied
Per the transformation definition rules, since DMS failed, manual conversion was applied with:
- **Conversion Method**: `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`
- All schema object names converted to lowercase
- SQL Server functions converted to PostgreSQL equivalents:
  - `GETDATE()` → `NOW()`
  - `DATEDIFF(YEAR, ...)` → `EXTRACT(YEAR FROM AGE(...))`
  - `FORMAT(date, 'format')` → `TO_CHAR(date, 'format')`
  - `DATEPART(YEAR, ...)` → `EXTRACT(YEAR FROM ...)`
  - `EXEC [dbo].[proc]` → `SELECT * FROM function()`

## SQL Equivalency Validation
All 5 statement pairs were validated through the SQL Equivalency MCP tool (sql-equivalency___validate_sql_equivalence) with proper table creation DDL for both MS SQL Server and PostgreSQL. All returned ERROR with `'uniqueID'` internal tool error. No agent judgment was used for equivalency determination.

### Equivalency Validation Timestamps
| Statement | Timestamp | Status |
|-----------|-----------|--------|
| Statement 1 (EditUsingStoredProcedure) | 2026-03-26T14:14:27.384329 | ERROR |
| Statement 2 (FindAllAuthorsEmbeddedSql) | 2026-03-26T14:14:38.243932 | ERROR |
| Statement 3 (DeleteAuthorEmbeddedSql) | 2026-03-26T14:15:13.385949 | ERROR |
| Statement 4 (SelectAuthorsByHireYear) | 2026-03-26T14:15:24.893051 | ERROR |
| Statement 5 (FindAllProducts) | 2026-03-26T14:15:35.710593 | ERROR |

## Detailed Statement Listing

### Statement 1: EditUsingStoredProcedure
- **Source File**: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: `EditUsingStoredProcedure`
- **Line**: ~165
- **Original MS SQL**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **Converted PostgreSQL**:
  ```sql
  SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source File**: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: `FindAllAuthorsEmbeddedSql`
- **Line**: ~190
- **Original MS SQL**:
  ```sql
  SELECT * FROM Author
  ```
- **Converted PostgreSQL**:
  ```sql
  SELECT * FROM author
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File**: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: `DeleteAuthorEmbeddedSql`
- **Line**: ~211
- **Original MS SQL**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **Converted PostgreSQL**:
  ```sql
  SELECT * FROM uspdeleteauthor(@BusinessEntityID);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

### Statement 4: SelectAuthorsByHireYear
- **Source File**: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: `SelectAuthorsByHireYear`
- **Line**: ~231
- **Original MS SQL**:
  ```sql
  SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
  ```
- **Converted PostgreSQL**:
  ```sql
  SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

### Statement 5: FindAllProducts
- **Source File**: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
- **Method**: `FindAllProducts`
- **Line**: ~36
- **Original MS SQL**:
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **Converted PostgreSQL**:
  ```sql
  SELECT * FROM uspgetproductdata();
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

## Package Changes

| Action | Package | Version |
|--------|---------|---------|
| Removed | Microsoft.EntityFrameworkCore.SqlServer | (previous) |
| Removed | Microsoft.Data.SqlClient | (previous) |
| Added | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 |

**Files Updated**:
- `sourceCode/app/Bookstore.Data/Bookstore.Data.csproj`
- `sourceCode/app/Bookstore.Web/Bookstore.Web.csproj`

## ADO.NET Class Replacements

| SQL Server Class | PostgreSQL Class | Files Updated |
|-----------------|-----------------|---------------|
| SqlConnection | NpgsqlConnection | ServicesSetup.cs |
| SqlParameter | NpgsqlParameter | AuthorsController.cs, ProductsController.cs |
| SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder | ServicesSetup.cs |
| UseSqlServer() | UseNpgsql() | ServicesSetup.cs |

## Connection String Updates

| SQL Server Parameter | PostgreSQL Parameter |
|---------------------|---------------------|
| Server= | Host= |
| Database= | Database= |
| SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder |

**Connection string format updated in**: `sourceCode/app/Bookstore.Web/Startup/ServicesSetup.cs`
- Uses `Host=`, `Port=`, `Database=` format (PostgreSQL)
- Uses `NpgsqlConnectionStringBuilder` for building connection strings
- Uses `Username` and `Password` properties

## Configuration Updates

| File | Change |
|------|--------|
| serviceDependencies.json | key: "mssql1" → "postgresql1", type: "postgresql" |
| serviceDependencies.local.json | key: "mssql1" → "postgresql1", type: "postgresql.local" |

## Static Code Verification Results

| Check | Result |
|-------|--------|
| Npgsql.EntityFrameworkCore.PostgreSQL in .csproj files | ✅ Present in both Bookstore.Data.csproj and Bookstore.Web.csproj |
| No Microsoft.Data.SqlClient references | ✅ None found |
| No Microsoft.EntityFrameworkCore.SqlServer references | ✅ None found |
| `using Npgsql;` in controller files | ✅ Present in AuthorsController.cs, ProductsController.cs, ServicesSetup.cs |
| NpgsqlParameter (not SqlParameter) | ✅ All 7 occurrences use NpgsqlParameter |
| NpgsqlConnectionStringBuilder (not SqlConnectionStringBuilder) | ✅ Used in ServicesSetup.cs |
| UseNpgsql (not UseSqlServer) | ✅ Used in ServicesSetup.cs |
| Host=/Port=/Database= connection string format | ✅ Present in ServicesSetup.cs |
| No residual SQL Server artifacts in source files | ✅ Zero SQL Server references found |

## Files Modified During Migration

| File | Changes Made |
|------|-------------|
| AuthorsController.cs | SQL statements converted to PostgreSQL, SqlParameter → NpgsqlParameter, using Npgsql added |
| ProductsController.cs | SQL statement converted to PostgreSQL, using Npgsql added |
| ServicesSetup.cs | UseSqlServer → UseNpgsql, SqlConnectionStringBuilder → NpgsqlConnectionStringBuilder, using Npgsql added, Host= format |
| Bookstore.Data.csproj | Microsoft.EntityFrameworkCore.SqlServer → Npgsql.EntityFrameworkCore.PostgreSQL |
| Bookstore.Web.csproj | Microsoft.EntityFrameworkCore.SqlServer → Npgsql.EntityFrameworkCore.PostgreSQL |
| serviceDependencies.json | mssql1 → postgresql1, type: postgresql |
| serviceDependencies.local.json | mssql1 → postgresql1, type: postgresql.local |

## Build Status
- **Final Build**: ✅ **SUCCEEDED** (0 errors, pre-existing warnings only)
- **Build Command**: `dotnet build BobsBookstore.sln`

## Artifacts Generated
1. **extracted_statements.sql** - Complete catalog of all 5 original MS SQL statements with source file locations, method names, and line numbers
2. **converted_statements.sql** - Complete catalog of all 5 converted PostgreSQL statements with DMS timestamps (original + retry), error messages, and conversion method documentation
3. **sql_equivalency_validation_report.json** - Comprehensive equivalency validation report for all 5 statement pairs with tool output timestamps
4. **migration_summary_report.md** - This report

## Remaining Items for Manual Review
All 5 SQL statement pairs returned ERROR from the SQL Equivalency validation tool (error: 'uniqueID'). This appears to be an internal tool infrastructure issue. These should be manually reviewed to confirm functional equivalence:
1. Statement 1 (EditUsingStoredProcedure) - Stored procedure call conversion to function call
2. Statement 2 (FindAllAuthorsEmbeddedSql) - Simple SELECT with table name case change (Author → author)
3. Statement 3 (DeleteAuthorEmbeddedSql) - Stored procedure call conversion to function call
4. Statement 4 (SelectAuthorsByHireYear) - Complex query with function conversions (FORMAT→TO_CHAR, DATEDIFF→EXTRACT, GETDATE→NOW, DATEPART→EXTRACT)
5. Statement 5 (FindAllProducts) - Stored procedure call conversion to function call
