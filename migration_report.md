# SQL Server to PostgreSQL Migration Report

## Migration Summary

**Application**: BobsBookstore .NET Web Application
**Migration Date**: 2026-03-23
**Source Database**: Microsoft SQL Server
**Target Database**: PostgreSQL
**Migration Scope**: SQL statement conversion, package dependencies, connection strings, ADO.NET classes, configuration

---

## SQL Statement Processing Summary

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Successfully converted by DMS MCP tool | 0 |
| Requiring manual intervention after DMS failure | 5 |
| Validated as equivalent by SQL Equivalency tool | 0 |
| Validated as non-equivalent | 0 |
| Equivalency validation errors | 5 |

### DMS Tool Status
All 5 statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`) twice with:
- `migration_project_identifier`: `arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U`
- `schema_name`: `dbo`
- `database_name`: `BobsBookstore`
- `server_name`: `172.31.82.226`
- `region`: `us-east-1`

**First attempt**: 2026-03-23T16:17 - All 5 conversions failed
**Second attempt**: 2026-03-23T16:39 - All 5 conversions failed

All conversions failed with error:
> Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.

Manual conversion was applied using `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA` approach for all 5 statements.

### SQL Equivalency Tool Status
All 5 statement pairs were validated through the SQL Equivalency tool (`sql-equivalency___validate_sql_equivalence`) with proper table creation statements for both MS SQL and PostgreSQL.
All 5 returned ERROR status with error: `'uniqueID'`.

**Note**: Equivalency statuses come exclusively from the SQL Equivalency tool output. No agent judgment was used to determine equivalency.

---

## Detailed Statement Listing

### Statement 1: EditUsingStoredProcedure
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `EditUsingStoredProcedure`
- **Original SQL** (MS SQL Server):
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **Converted SQL** (PostgreSQL):
  ```sql
  SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Failure Reason**: Metadata model creation failed: No objects were found according to the specified selection rules.
- **Equivalency Status**: ERROR (from SQL Equivalency tool - error: 'uniqueID')

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `FindAllAuthorsEmbeddedSql`
- **Original SQL** (MS SQL Server):
  ```sql
  SELECT * FROM dbo.Author
  ```
- **Converted SQL** (PostgreSQL):
  ```sql
  SELECT * FROM bobsbookstore_dbo.author
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Failure Reason**: Metadata model creation failed: No objects were found according to the specified selection rules.
- **Equivalency Status**: ERROR (from SQL Equivalency tool - error: 'uniqueID')

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `DeleteAuthorEmbeddedSql`
- **Original SQL** (MS SQL Server):
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **Converted SQL** (PostgreSQL):
  ```sql
  SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Failure Reason**: Metadata model creation failed: No objects were found according to the specified selection rules.
- **Equivalency Status**: ERROR (from SQL Equivalency tool - error: 'uniqueID')

### Statement 4: SelectAuthorsByHireYear
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `SelectAuthorsByHireYear`
- **Original SQL** (MS SQL Server):
  ```sql
  SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE YEAR(HireDate) = @HireDate
  ```
- **Converted SQL** (PostgreSQL):
  ```sql
  SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Failure Reason**: Metadata model creation failed: No objects were found according to the specified selection rules.
- **Equivalency Status**: ERROR (from SQL Equivalency tool - error: 'uniqueID')
- **Function Mappings Applied**:
  - `CONVERT(VARCHAR, col, 120)` → `TO_CHAR(col, 'YYYY-MM-DD HH24:MI:SS')`
  - `DATEDIFF(YEAR, col, GETDATE())` → `EXTRACT(YEAR FROM AGE(CURRENT_DATE, col))::INTEGER`
  - `YEAR(col)` → `EXTRACT(YEAR FROM col)`
  - `GETDATE()` → `CURRENT_DATE`

### Statement 5: FindAllProducts
- **Source File**: `app/Bookstore.Web/Controllers/ProductsController.cs`
- **Method**: `FindAllProducts`
- **Original SQL** (MS SQL Server):
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **Converted SQL** (PostgreSQL):
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Failure Reason**: Metadata model creation failed: No objects were found according to the specified selection rules.
- **Equivalency Status**: ERROR (from SQL Equivalency tool - error: 'uniqueID')

---

## Static Code Migration Status

### Package Dependencies

| Original Package | Replaced With | Status |
|-----------------|---------------|--------|
| `Microsoft.Data.SqlClient` | Removed (not needed with EF Core) | ✅ Complete |
| `Microsoft.EntityFrameworkCore.SqlServer` | `Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0` | ✅ Complete |

### .csproj File Changes

| File | Npgsql Package | SQL Server Package | Status |
|------|---------------|-------------------|--------|
| `Bookstore.Data.csproj` | `Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0` ✅ | None ✅ | ✅ Complete |
| `Bookstore.Web.csproj` | `Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0` ✅ | None ✅ | ✅ Complete |
| `Bookstore.Domain.csproj` | N/A (no DB refs) | None ✅ | ✅ Complete |

### ADO.NET Class Replacements

| Original Class | Replacement | Files Affected | Status |
|---------------|-------------|----------------|--------|
| `SqlConnection` | Not used (EF Core manages connections) | N/A | ✅ Complete |
| `SqlCommand` | Not used (EF Core `ExecuteSqlRawAsync`/`SqlQueryRaw`) | N/A | ✅ Complete |
| `SqlDataReader` | Not used (EF Core manages readers) | N/A | ✅ Complete |
| `SqlParameter` | `NpgsqlParameter` | AuthorsController.cs | ✅ Complete |
| `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` | ServicesSetup.cs | ✅ Complete |
| `using Microsoft.Data.SqlClient` | `using Npgsql` | AuthorsController.cs, ProductsController.cs, ServicesSetup.cs | ✅ Complete |

### Database Provider Configuration

| Component | Original | Migrated | Status |
|-----------|----------|----------|--------|
| EF Core Provider | `UseSqlServer()` | `UseNpgsql()` | ✅ Complete |
| Connection String Builder | `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` | ✅ Complete |
| Connection Parameters | Server, Database, IntegratedSecurity | Host, Port, Database, Username, Password | ✅ Complete |
| DbContext Schema | `dbo` | `bobsbookstore_dbo` | ✅ Complete |
| Entity Names | PascalCase | lowercase | ✅ Complete |
| Timestamp Behavior | Default | `Npgsql.EnableLegacyTimestampBehavior = true` | ✅ Complete |

### Service Dependencies

| File | Original Type | Migrated Type | Status |
|------|--------------|---------------|--------|
| `serviceDependencies.json` | `mssql` | `npgsql` | ✅ Complete |
| `serviceDependencies.local.json` | `mssql.local` | `npgsql.local` | ✅ Complete |

---

## Files Modified During Migration

| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | Replaced 4 SQL statements with PostgreSQL equivalents, updated `using` to `Npgsql`, replaced `SqlParameter` with `NpgsqlParameter` |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | Replaced 1 SQL statement with PostgreSQL equivalent, updated `using` to `Npgsql` |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | Updated to use `UseNpgsql()` and `NpgsqlConnectionStringBuilder`, updated `using` to `Npgsql` |
| `app/Bookstore.Data/ApplicationDbContext.cs` | Updated to use `bobsbookstore_dbo` schema, lowercase entity names, added `Npgsql.EnableLegacyTimestampBehavior` |
| `app/Bookstore.Data/Bookstore.Data.csproj` | Replaced `Microsoft.EntityFrameworkCore.SqlServer` with `Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0` |
| `app/Bookstore.Web/Bookstore.Web.csproj` | Added `Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0` |
| `app/Bookstore.Web/Properties/serviceDependencies.json` | Changed type from `mssql` to `npgsql` |
| `app/Bookstore.Web/Properties/serviceDependencies.local.json` | Changed type from `mssql.local` to `npgsql.local` |

---

## Remaining SQL Server References

**NONE** - A comprehensive search across all `.cs` files confirmed no remaining references to:
- `SqlConnection`
- `SqlCommand`
- `SqlDataReader`
- `SqlParameter`
- `System.Data.SqlClient`
- `Microsoft.Data.SqlClient`
- `UseSqlServer`
- `SqlConnectionStringBuilder`

---

## Statements Requiring Manual Review

All 5 statements require manual review due to:
1. **DMS conversion failure**: The DMS MCP tool failed for all statements (both attempts) with "Metadata model creation failed" error. Manual conversion was applied using lowercase schema naming conventions.
2. **Equivalency validation errors**: The SQL Equivalency tool returned ERROR ('uniqueID') for all 5 statement pairs, meaning equivalency could not be programmatically verified.

**Recommendation**: Manually verify each converted SQL statement against the actual PostgreSQL database to ensure functional correctness, especially:
- Stored procedure calls (Statements 1, 3, 5) - Verify the PostgreSQL functions exist with the expected signatures
- Table/column name casing (Statements 2, 4) - Verify lowercase names match the actual database schema
- CONVERT/DATEDIFF/GETDATE/YEAR functions (Statement 4) - Verify TO_CHAR/EXTRACT/AGE/CURRENT_DATE equivalents produce correct results

---

## Migration Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| Extracted SQL statements | `extracted_statements.sql` | Complete catalog of 5 original MS SQL statements |
| Converted SQL statements | `converted_statements.sql` | Complete catalog of 5 converted PostgreSQL statements with DMS documentation |
| SQL Equivalency Report | `sql_equivalency_validation_report.json` | Comprehensive validation report for all 5 statement pairs |
| Migration Report | `migration_report.md` | This report |

---

## Build Validation

**Final Build Status**: ✅ SUCCESS
- Command: `dotnet build BobsBookstore.sln`
- Result: Build succeeded with 0 errors, 184 warnings (all pre-existing NuGet vulnerability and deprecation warnings)
- All projects compiled: Bookstore.Domain, Bookstore.Data, Bookstore.Web
