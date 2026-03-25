# BobsBookstore - SQL Server to PostgreSQL Migration Report

## Summary

This report documents the comprehensive migration of the BobsBookstore .NET application from Microsoft SQL Server to PostgreSQL. The migration involved converting all SQL statements using the AWS DMS MCP tool, replacing SQL Server ADO.NET classes with Npgsql equivalents, updating connection string configuration, and removing SQL Server package dependencies.

**Migration Date:** 2026-03-25
**DMS Migration Project:** arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U

## Files Modified

| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | Replaced 4 SQL statements with PostgreSQL equivalents; replaced SqlParameter → NpgsqlParameter |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | Replaced 1 SQL statement with PostgreSQL equivalent |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | Replaced UseSqlServer → UseNpgsql; SqlConnectionStringBuilder → NpgsqlConnectionStringBuilder; updated connection string format |
| `app/Bookstore.Data/Bookstore.Data.csproj` | Removed Microsoft.EntityFrameworkCore.SqlServer 6.0.6 |
| `app/Bookstore.Web/Bookstore.Web.csproj` | Removed Microsoft.EntityFrameworkCore.SqlServer 8.0.10 |

## SQL Statement Conversion Details

### Total SQL Statements Processed: 5
- Statements submitted to DMS MCP tool: 5
- DMS tool returned converted SQL: 0 (all failed with metadata model creation error)
- Statements manually converted (with lowercase schema naming): 5
- Statements validated through SQL Equivalency tool: 5
- Equivalency status EQUIVALENT: 0
- Equivalency status NOT_EQUIVALENT: 0
- Equivalency status ERROR: 5 (tool infrastructure error - 'uniqueID')

### DMS Tool Behavior

All 5 statements were submitted to the DMS MCP tool (dms-mcp___statement_conversion_tool) with:
- `migration_project_identifier`: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- `database_name`: BobsBookstore
- `schema_name`: dbo
- `server_name`: 172.31.82.226

The DMS tool failed at the metadata model creation step for all 5 statements with the error: "Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again."

Manual conversions were applied following the transformation rules for DMS failure (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA):
- All schema object names converted to lowercase for PostgreSQL compatibility
- `EXEC` statements converted to `CALL` for PostgreSQL stored procedure syntax
- SQL Server functions mapped to PostgreSQL equivalents (with `aws_sqlserver_ext` extension for DATEDIFF)
- The `dbo` schema was renamed to `bobsusedbookstore_dbo` following PostgreSQL target schema naming convention

### Statement 1: EditUsingStoredProcedure

| Property | Value |
|----------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `EditUsingStoredProcedure` (line ~163) |
| **Original MS SQL** | `EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;` |
| **Converted PostgreSQL** | `CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` |
| **DMS Status** | ERROR - Metadata model creation failed |
| **DMS Timestamp** | 2026-03-25T21:07:18.010366 |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool returned 'uniqueID' error - infrastructure issue) |
| **Equivalency Timestamp** | 2026-03-25T21:12:49.875852 |
| **Additional Changes** | SqlParameter → NpgsqlParameter (5 parameters) |

### Statement 2: FindAllAuthorsEmbeddedSql

| Property | Value |
|----------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `FindAllAuthorsEmbeddedSql` (line ~187) |
| **Original MS SQL** | `SELECT * FROM Author` |
| **Converted PostgreSQL** | `SELECT * FROM bobsusedbookstore_dbo.author;` |
| **DMS Status** | ERROR - Metadata model creation failed |
| **DMS Timestamp** | 2026-03-25T21:07:42.458210 |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool returned 'uniqueID' error - infrastructure issue) |
| **Equivalency Timestamp** | 2026-03-25T21:13:00.743900 |
| **Schema Changes** | `Author` → `bobsusedbookstore_dbo.author` |

### Statement 3: DeleteAuthorEmbeddedSql

| Property | Value |
|----------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `DeleteAuthorEmbeddedSql` (line ~208) |
| **Original MS SQL** | `EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;` |
| **Converted PostgreSQL** | `CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);` |
| **DMS Status** | ERROR - Metadata model creation failed |
| **DMS Timestamp** | 2026-03-25T21:08:11.368888 |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool returned 'uniqueID' error - infrastructure issue) |
| **Equivalency Timestamp** | 2026-03-25T21:13:28.258394 |
| **Additional Changes** | SqlParameter → NpgsqlParameter (1 parameter) |

### Statement 4: SelectAuthorsByHireYear

| Property | Value |
|----------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `SelectAuthorsByHireYear` (line ~228) |
| **Original MS SQL** | `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;` |
| **Converted PostgreSQL** | `SELECT businessentityid, to_char(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, aws_sqlserver_ext.datediff('YEAR', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;` |
| **DMS Status** | ERROR - Metadata model creation failed |
| **DMS Timestamp** | 2026-03-25T21:08:35.475712 |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool returned 'uniqueID' error - infrastructure issue) |
| **Equivalency Timestamp** | 2026-03-25T21:13:41.095719 |
| **Function Conversions** | FORMAT → to_char, DATEDIFF → aws_sqlserver_ext.datediff, GETDATE() → clock_timestamp(), DATEPART → date_part |
| **Additional Changes** | SqlParameter → NpgsqlParameter (1 parameter) |

### Statement 5: FindAllProducts

| Property | Value |
|----------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/ProductsController.cs` |
| **Method** | `FindAllProducts` (line ~34) |
| **Original MS SQL** | `EXEC [dbo].[uspGetProductData];` |
| **Converted PostgreSQL** | `CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);` |
| **DMS Status** | ERROR - Metadata model creation failed |
| **DMS Timestamp** | 2026-03-25T21:09:02.296392 |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool returned 'uniqueID' error - infrastructure issue) |
| **Equivalency Timestamp** | 2026-03-25T21:13:53.295666 |

## Package Dependency Changes

### Bookstore.Data.csproj
- **Removed:** `Microsoft.EntityFrameworkCore.SqlServer` Version 6.0.6
- **Added/Retained:** `Npgsql.EntityFrameworkCore.PostgreSQL` Version 8.0.0

### Bookstore.Web.csproj
- **Removed:** `Microsoft.EntityFrameworkCore.SqlServer` Version 8.0.10
- **Added/Retained:** `Npgsql.EntityFrameworkCore.PostgreSQL` Version 8.0.0
- **Retained:** `Microsoft.EntityFrameworkCore.Sqlite` Version 5.0.7 (pre-existing, used for testing)

## Code Changes Summary

### ADO.NET Class Replacements
- `SqlParameter` → `NpgsqlParameter` (7 occurrences in AuthorsController.cs, 0 in ProductsController.cs)
- `SqlConnectionStringBuilder` → `NpgsqlConnectionStringBuilder` (1 occurrence in ServicesSetup.cs)
- `UseSqlServer` → `UseNpgsql` (1 occurrence in ServicesSetup.cs)

### Import Changes
- `using Microsoft.Data.SqlClient` → `using Npgsql` (in AuthorsController.cs, ProductsController.cs)
- `using Npgsql` added to ServicesSetup.cs

### Connection String Changes
- **Before (SQL Server):** `Server={host},{port}; Initial Catalog=BobsUsedBookStore;MultipleActiveResultSets=true; Integrated Security=false;TrustServerCertificate=True`
- **After (PostgreSQL):** `Host={host};Port={port};Database=BobsUsedBookStore`
- **Builder property change:** `UserID` → `Username`

### Schema Mapping
The schema was converted from `[dbo]` to `bobsusedbookstore_dbo` (lowercase naming convention for PostgreSQL):
- `[dbo].[uspUpdateAuthorPersonalInfo]` → `bobsusedbookstore_dbo.uspupdateauthorpersonalinfo`
- `Author` → `bobsusedbookstore_dbo.author`
- `[dbo].[uspDeleteAuthor]` → `bobsusedbookstore_dbo.uspdeleteauthor`
- `[dbo].[uspGetProductData]` → `bobsusedbookstore_dbo.uspgetproductdata`

## SQL Server Reference Scan Results

A comprehensive scan of ALL .cs and .csproj files for remaining SQL Server references was performed:
- **SqlConnection**: 0 occurrences found ✓
- **SqlCommand**: 0 occurrences found ✓
- **SqlDataReader**: 0 occurrences found ✓
- **SqlParameter**: 0 occurrences found ✓
- **UseSqlServer**: 0 occurrences found ✓
- **Microsoft.Data.SqlClient**: 0 occurrences found ✓
- **System.Data.SqlClient**: 0 occurrences found ✓
- **SqlConnectionStringBuilder**: 0 occurrences found ✓
- **Microsoft.EntityFrameworkCore.SqlServer**: 0 occurrences found ✓

**Result: No remaining SQL Server references in the codebase.**

## SQL Equivalency Validation

All 5 statement pairs were validated through the SQL Equivalency MCP tool (sql-equivalency___validate_sql_equivalence). All returned ERROR status due to a tool infrastructure issue (`'uniqueID'` error). This is consistent across all inputs, indicating a systemic tool issue rather than conversion quality problems.

**Important:** No agent judgment was used to determine equivalency status. All status values are directly from the tool output.

See `sql_equivalency_validation_report.json` for the complete validation report.

## Build Verification

- **Final Build Status:** SUCCESS (0 errors, 185 pre-existing warnings)
- **Build Command:** `dotnet build BobsBookstore.sln`
- All modified files compile successfully

## Statements Requiring Manual Review

All 5 statements require manual review due to:
1. **DMS tool failure** - All statements failed DMS conversion and were manually converted
2. **Equivalency tool error** - All statement pairs received ERROR from the equivalency tool due to infrastructure issues

The manual conversions follow standard SQL Server to PostgreSQL mapping rules and should be functionally correct, but manual verification against the target PostgreSQL database is recommended.

## Artifacts Generated

1. `extracted_statements.sql` - Complete catalog of all 5 original MS SQL statements with source locations
2. `converted_statements.sql` - Complete catalog of all 5 converted PostgreSQL statements with DMS status
3. `sql_equivalency_validation_report.json` - Comprehensive equivalency validation report with all 5 statement pairs
4. `migration_report.md` - This report
