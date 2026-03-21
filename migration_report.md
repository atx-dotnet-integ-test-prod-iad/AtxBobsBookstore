# BobsBookstore - SQL Server to PostgreSQL Migration Report

## Summary

This report documents the migration of the BobsBookstore .NET application from Microsoft SQL Server to PostgreSQL.

## SQL Statement Processing

| Metric | Count |
|--------|-------|
| **Total SQL Statements Processed** | 5 |
| **Successfully Converted by DMS** | 0 |
| **Manual Conversion Required (DMS Failed)** | 5 |
| **Equivalency Validated as EQUIVALENT** | 0 |
| **Equivalency Validated as NOT_EQUIVALENT** | 0 |
| **Equivalency Validation ERROR** | 5 |

### DMS Conversion Details

All 5 statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`) with parameters:
- `database_name`: BobsBookstore
- `schema_name`: dbo
- `migration_project_identifier`: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U

All 5 DMS calls failed with the same error:
> Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.

Manual conversion was applied with lowercase schema object names per the transformation definition (`DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`).

### Statement Conversion Details

| # | Source File | Original SQL | Converted PostgreSQL | Method |
|---|-------------|-------------|---------------------|--------|
| 1 | AuthorsController.cs:165 | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;` | `SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` | Manual |
| 2 | AuthorsController.cs:189 | `SELECT * FROM bobsbookstore_dbo.author` | `SELECT * FROM bobsbookstore_dbo.author` | Manual |
| 3 | AuthorsController.cs:212 | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;` | `SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);` | Manual |
| 4 | AuthorsController.cs:232 | `SELECT BusinessEntityID, TO_CHAR(ModifiedDate, ...) AS FormattedModifiedDate, EXTRACT(...) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;` | `SELECT businessentityid, TO_CHAR(modifieddate, ...) AS formattedmodifieddate, EXTRACT(...) AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;` | Manual |
| 5 | ProductsController.cs:36 | `EXEC [dbo].[uspGetProductData];` | `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();` | Manual |

### SQL Equivalency Validation

All 5 statement pairs were validated through the SQL Equivalency MCP tool (`sql-equivalency___validate_sql_equivalence`). All 5 returned ERROR status with error: `'uniqueID'`. Full details are in `sql_equivalency_validation_report.json`.

## Package Dependencies

| Project | Status | Details |
|---------|--------|---------|
| Bookstore.Data.csproj | ✅ PASS | `Npgsql.EntityFrameworkCore.PostgreSQL 8.0.10` present. No SQL Server packages. |
| Bookstore.Web.csproj | ✅ PASS | `Npgsql.EntityFrameworkCore.PostgreSQL 8.0.10` present. No SQL Server packages. |
| Bookstore.Domain.csproj | ✅ PASS | No database-specific dependencies. |

## ADO.NET Classes

| Check | Status |
|-------|--------|
| `using Npgsql` in controllers | ✅ PASS (AuthorsController.cs, ProductsController.cs, ServicesSetup.cs) |
| No `Microsoft.Data.SqlClient` references | ✅ PASS |
| No `System.Data.SqlClient` references | ✅ PASS |
| `NpgsqlParameter` for parameter binding | ✅ PASS (7 usages found) |
| `NpgsqlConnectionStringBuilder` for connection | ✅ PASS (ServicesSetup.cs) |
| `UseNpgsql()` for DbContext | ✅ PASS (ServicesSetup.cs) |

## Connection Strings

| Check | Status |
|-------|--------|
| NpgsqlConnectionStringBuilder usage | ✅ PASS |
| Host property | ✅ PASS |
| Port property | ✅ PASS |
| Database property | ✅ PASS |
| Username property | ✅ PASS |
| Password property | ✅ PASS |
| Npgsql.EnableLegacyTimestampBehavior | ✅ PASS |

## Entity Framework Mappings

| Check | Status |
|-------|--------|
| Entities mapped to `bobsbookstore_dbo` schema | ✅ PASS (11 entities) |
| Lowercase column name mappings | ✅ PASS (104 column mappings) |

## Files Modified During Migration

### SQL Statement Re-integration (Step 3)
- `app/Bookstore.Web/Controllers/AuthorsController.cs` - 4 SQL statements converted, 2 TODO comments removed
- `app/Bookstore.Web/Controllers/ProductsController.cs` - 1 SQL statement converted, 1 TODO comment removed

### Artifacts Created
- `extracted_statements.sql` - Catalog of all 5 original SQL statements
- `converted_statements.sql` - Catalog of all 5 original + converted statement pairs
- `sql_equivalency_validation_report.json` - Complete equivalency validation report
- `migration_report.md` - This report

## Build Status

✅ **Build succeeded** with 0 errors and 184 warnings (all pre-existing).

## Remaining Manual Review Items

1. **DMS Tool Failures**: All 5 DMS conversions failed. Manual conversions were applied using lowercase schema object naming conventions. These should be reviewed to ensure the stored procedure names and schema mappings match the actual PostgreSQL database.

2. **SQL Equivalency Errors**: All 5 equivalency validations returned ERROR. This appears to be a tool-level issue (all returned the same `'uniqueID'` error). The converted statements should be functionally tested against the PostgreSQL database.

3. **Stored Procedure Existence**: The following PostgreSQL functions/procedures must exist in the `bobsbookstore_dbo` schema:
   - `bobsbookstore_dbo.uspupdateauthorpersonalinfo(INT, VARCHAR, TIMESTAMP, CHAR, CHAR)`
   - `bobsbookstore_dbo.uspdeleteauthor(INT)`
   - `bobsbookstore_dbo.uspgetproductdata()`

4. **Parameter Binding**: Npgsql parameters use `@` prefix (e.g., `@BusinessEntityID`). This is compatible with Npgsql's parameter handling, but should be verified in integration testing.
