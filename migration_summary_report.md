# Migration Summary Report: SQL Server to PostgreSQL
## BobsBookstore .NET Application
### Date: 2026-03-26

---

## 1. Overview

This report documents the migration of the BobsBookstore .NET ADO application from Microsoft SQL Server to PostgreSQL. The migration involved extracting, converting, and re-integrating SQL statements, updating package dependencies, connection strings, and ADO.NET data access classes.

---

## 2. SQL Statement Migration Summary

### Total Statements Processed: 5

| # | Source File | Method | Original MS SQL | Converted PostgreSQL | Conversion Method | DMS Result |
|---|------------|--------|----------------|---------------------|-------------------|------------|
| 1 | AuthorsController.cs | FindAllAuthorsEmbeddedSql | `SELECT * FROM Author` | `SELECT * FROM author` | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | Failed: Metadata model creation failed |
| 2 | AuthorsController.cs | EditUsingStoredProcedure | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected` | `SELECT dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | Failed: Metadata model creation failed |
| 3 | AuthorsController.cs | DeleteAuthorEmbeddedSql | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected` | `SELECT dbo.uspdeleteauthor(@BusinessEntityID);` | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | Failed: Metadata model creation failed |
| 4 | AuthorsController.cs | SelectAuthorsByHireYear | `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate` | `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;` | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | Failed: Metadata model creation failed |
| 5 | ProductsController.cs | FindAllProducts | `EXEC [dbo].[uspGetProductData]` | `SELECT * FROM dbo.uspgetproductdata();` | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | Failed: Metadata model creation failed |

### DMS Conversion Results
- **Statements passed through DMS MCP tool**: 5/5
- **Successfully converted by DMS**: 0
- **DMS failures requiring manual conversion**: 5
- **DMS Error**: "Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again."
- **DMS Timestamps**: 2026-03-26T00:03:04 through 2026-03-26T00:04:56

### SQL Conversion Details
- **Statement 1**: Simple SELECT - converted table name to lowercase (`Author` → `author`)
- **Statement 2**: Stored procedure EXEC with output parameter - converted to PostgreSQL function call syntax (`SELECT dbo.uspupdateauthorpersonalinfo(...)`)
- **Statement 3**: Stored procedure EXEC with output parameter - converted to PostgreSQL function call syntax (`SELECT dbo.uspdeleteauthor(...)`)
- **Statement 4**: Complex SELECT with SQL Server date functions - converted `FORMAT()` → `TO_CHAR()`, `DATEDIFF()` → `EXTRACT()`, `GETDATE()` → `CURRENT_DATE`, `DATEPART()` → `EXTRACT()`; all schema objects lowercased
- **Statement 5**: Stored procedure EXEC - converted to PostgreSQL function call syntax (`SELECT * FROM dbo.uspgetproductdata()`)

---

## 3. SQL Equivalency Validation Results

All 5 statement pairs were validated using the SQL Equivalency MCP tool (sql-equivalency___validate_sql_equivalence).

| Metric | Count |
|--------|-------|
| Statements processed | 5 |
| Equivalent | 0 |
| Non-equivalent | 0 |
| Errors | 5 |

**Note**: All 5 equivalency validations returned ERROR status from the tool with error `'uniqueID'`. This is a tool-side error, not a reflection of the conversion quality. Per transformation rules, equivalency status is taken solely from the tool output without agent judgment.

Full equivalency report is available in `sql_equivalency_validation_report.json`.

---

## 4. Package/Dependency Changes

### Removed
- `Microsoft.Data.SqlClient` - Removed (was SQL Server ADO.NET provider)
- `System.Data.SqlClient` - Not present (confirmed)
- `Microsoft.EntityFrameworkCore.SqlServer` - Not present (confirmed)
- `Microsoft.EntityFrameworkCore.Sqlite` Version 5.0.7 - Removed from Bookstore.Web.csproj (unused, not referenced in any source file)

### Added/Retained
- `Npgsql.EntityFrameworkCore.PostgreSQL` Version `8.0.0` - In both Bookstore.Data.csproj and Bookstore.Web.csproj
- `Npgsql` - Implicit dependency through Npgsql.EntityFrameworkCore.PostgreSQL

### Verification
- No `Microsoft.Data.SqlClient`, `System.Data.SqlClient`, or `Microsoft.EntityFrameworkCore.SqlServer` references remain in any .csproj or .cs files
- No `Microsoft.EntityFrameworkCore.Sqlite` references remain (package removed, not used in code)

---

## 5. Connection String Changes

### Before (SQL Server)
- Used `SqlConnectionStringBuilder` 
- Connection format: `Server=;Database=;Integrated Security=true`

### After (PostgreSQL)
- Uses `NpgsqlConnectionStringBuilder` (ServicesSetup.cs line 94)
- Connection format: `Host={host};Port={port};Database=BobsUsedBookStore;Username={username};Password={password}`
- `UseNpgsql()` configured in DI setup (ServicesSetup.cs line 35)
- Comments updated to reference PostgreSQL instead of SQL Server
- Credentials managed via AWS Secrets Manager (secure, no hardcoded secrets)

---

## 6. ADO.NET Class Changes

| SQL Server Class | PostgreSQL Equivalent | Status |
|-----------------|----------------------|--------|
| `SqlConnection` | `NpgsqlConnection` | ✅ Replaced (via EF Core) |
| `SqlCommand` | `NpgsqlCommand` | ✅ Replaced (via EF Core) |
| `SqlDataReader` | `NpgsqlDataReader` | ✅ Replaced (via EF Core) |
| `SqlParameter` | `NpgsqlParameter` | ✅ Replaced (7 instances in AuthorsController.cs) |
| `using Microsoft.Data.SqlClient` | `using Npgsql` | ✅ Replaced in all controller files and ServicesSetup.cs |

---

## 7. Files Modified

| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | SQL statements converted to PostgreSQL; `using Npgsql`; `NpgsqlParameter` usage |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | SQL statement converted to PostgreSQL; `using Npgsql` |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | `NpgsqlConnectionStringBuilder`, `UseNpgsql()`, `using Npgsql`; comment updated |
| `app/Bookstore.Data/Bookstore.Data.csproj` | `Npgsql.EntityFrameworkCore.PostgreSQL` package |
| `app/Bookstore.Web/Bookstore.Web.csproj` | `Npgsql.EntityFrameworkCore.PostgreSQL` package; removed unused `Microsoft.EntityFrameworkCore.Sqlite` |

---

## 8. Transformation Artifacts

| Artifact | Location | Status |
|----------|----------|--------|
| Extracted SQL statements catalog | `extracted_statements.sql` | ✅ Complete (5/5 statements) |
| Converted SQL statements catalog | `converted_statements.sql` | ✅ Complete (5/5 statements) |
| SQL Equivalency validation report | `sql_equivalency_validation_report.json` | ✅ Complete (5/5 statement pairs) |
| Migration summary report | `migration_summary_report.md` (this file) | ✅ Complete |

---

## 9. Build Status

Build verification performed using `dotnet build BobsBookstore.sln`.
- **Result**: ✅ SUCCESS
- **Errors**: 0
- **Warnings**: 184 (all pre-existing, not related to migration)

---

## 10. Known Issues and Recommendations

1. **DMS Tool Metadata Model**: All DMS conversions failed due to metadata model creation failure. The migration project may need reconfiguration of selection rules to resolve this for future conversions.

2. **Equivalency Validation Errors**: All equivalency checks returned ERROR from the tool (error: `'uniqueID'`). This is a tool-side error and requires manual review to confirm conversion correctness.

3. **Stored Procedure Migration**: The converted SQL calls PostgreSQL functions (`dbo.uspupdateauthorpersonalinfo`, `dbo.uspdeleteauthor`, `dbo.uspgetproductdata`). These functions must exist in the target PostgreSQL database with matching signatures.

4. **Schema Objects**: All schema object names have been lowercased per PostgreSQL conventions. The target database schema must use lowercase names correspondingly.

5. **Unused Sqlite Package**: Removed `Microsoft.EntityFrameworkCore.Sqlite` (5.0.7) from Bookstore.Web.csproj as it was not referenced in any source file and is not needed for the PostgreSQL migration.
