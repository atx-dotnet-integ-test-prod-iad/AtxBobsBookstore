# BobsBookstore Migration Report: Microsoft SQL Server to PostgreSQL

## Migration Summary

| Item | Value |
|------|-------|
| **Application** | BobsBookstore (.NET 8.0 ADO.NET Application) |
| **Source Database** | Microsoft SQL Server |
| **Target Database** | PostgreSQL |
| **Migration Date** | 2026-03-27 |
| **Total SQL Statements** | 5 |
| **Files with SQL** | 2 (AuthorsController.cs, ProductsController.cs) |

---

## SQL Statement Conversion Summary

| Metric | Count |
|--------|-------|
| Total statements processed | 5 |
| Statements converted by DMS MCP tool | 0 |
| Statements requiring manual conversion (DMS failure) | 5 |
| Statements validated as EQUIVALENT | 0 |
| Statements validated as NOT_EQUIVALENT | 0 |
| Statements with equivalency ERROR | 5 |

### DMS Tool Status
All 5 statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`). All 5 failed with the same error:
- **Error**: `Metadata model creation failed: No objects were found according to the specified selection rules.`
- **Migration Project ARN**: `arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U`
- **Parameters**: database_name=BobsBookstore, schema_name=dbo, region=us-east-1

Manual conversion was applied using `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA` rules.

### SQL Equivalency Tool Status
All 5 statement pairs were validated using the SQL Equivalency MCP tool (`sql-equivalency___validate_sql_equivalence`). All 5 returned ERROR with `'uniqueID'` error from the tool. Equivalency statuses are exclusively from the tool output - no agent judgment was used.

---

## Detailed SQL Statement Listing

### Statement 1: EditUsingStoredProcedure

| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `EditUsingStoredProcedure` |
| **Type** | Stored procedure call with DECLARE/EXEC pattern, 5 parameters |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (from tool) |

**Original MS SQL:**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5);
```

**Conversion Details:**
- Schema: `[dbo].[uspUpdateAuthorPersonalInfo]` → `bobsbookstore_dbo.uspupdateauthorpersonalinfo`
- Pattern: `DECLARE/EXEC/SELECT @rowsAffected` → `SELECT * FROM function()`
- Parameters: `@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender` → `$1, $2, $3, $4, $5`

---

### Statement 2: FindAllAuthorsEmbeddedSql

| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `FindAllAuthorsEmbeddedSql` |
| **Type** | Simple SELECT query |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (from tool) |

**Original MS SQL:**
```sql
SELECT * FROM [dbo].[Author]
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.author;
```

**Conversion Details:**
- Schema: `[dbo].[Author]` → `bobsbookstore_dbo.author`

---

### Statement 3: DeleteAuthorEmbeddedSql

| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `DeleteAuthorEmbeddedSql` |
| **Type** | Stored procedure call with DECLARE/EXEC pattern, 1 parameter |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (from tool) |

**Original MS SQL:**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor($1);
```

**Conversion Details:**
- Schema: `[dbo].[uspDeleteAuthor]` → `bobsbookstore_dbo.uspdeleteauthor`
- Pattern: `DECLARE/EXEC/SELECT @rowsAffected` → `SELECT * FROM function()`
- Parameters: `@BusinessEntityID` → `$1`

---

### Statement 4: SelectAuthorsByHireYear

| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `SelectAuthorsByHireYear` |
| **Type** | Complex SELECT with SQL Server functions (CONVERT, DATEDIFF, GETDATE, YEAR) |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (from tool) |

**Original MS SQL:**
```sql
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireYear;
```

**Converted PostgreSQL:**
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = $1;
```

**Conversion Details:**
- `CONVERT(VARCHAR, ModifiedDate, 120)` → `TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')`
- `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(birthdate))::INTEGER`
- `YEAR(HireDate)` → `EXTRACT(YEAR FROM hiredate)`
- Schema: `[dbo].[Author]` → `bobsbookstore_dbo.author`
- All column names lowercased
- Parameters: `@HireYear` → `$1`

---

### Statement 5: FindAllProducts

| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/ProductsController.cs` |
| **Method** | `FindAllProducts` |
| **Type** | Stored procedure execution (no parameters) |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (from tool) |

**Original MS SQL:**
```sql
EXEC [dbo].[uspGetProductData];
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
```

**Conversion Details:**
- Schema: `[dbo].[uspGetProductData]` → `bobsbookstore_dbo.uspgetproductdata`
- Pattern: `EXEC procedure` → `SELECT * FROM function()`

---

## Files Modified During Migration

### Source Code Files
| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | SQL statements converted to PostgreSQL, `using Npgsql;` import, NpgsqlParameter with positional parameters |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | SQL statement converted to PostgreSQL, `using Npgsql;` import |
| `app/Bookstore.Data/ApplicationDbContext.cs` | Entity mappings to `bobsbookstore_dbo` schema, `Npgsql.EnableLegacyTimestampBehavior` switch, lowercase column names |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | `UseNpgsql()`, `NpgsqlConnectionStringBuilder` with Host/Port/Database/Username/Password |

### Configuration Files
| File | Changes |
|------|---------|
| `app/Bookstore.Data/Bookstore.Data.csproj` | `Npgsql.EntityFrameworkCore.PostgreSQL` 8.0.0 (replaces SqlClient) |
| `app/Bookstore.Web/Bookstore.Web.csproj` | `Npgsql.EntityFrameworkCore.PostgreSQL` 8.0.0 (replaces SqlClient) |
| `app/Bookstore.Web/Properties/serviceDependencies.json` | `type: postgresql` |
| `app/Bookstore.Web/Properties/serviceDependencies.local.json` | `type: postgresql.local` |

---

## Package Dependency Changes

| Original Package | New Package | Version |
|------------------|-------------|---------|
| `Microsoft.Data.SqlClient` | `Npgsql.EntityFrameworkCore.PostgreSQL` | 8.0.0 |

---

## Connection String Changes

| Component | Before (SQL Server) | After (PostgreSQL) |
|-----------|--------------------|--------------------|
| Builder Class | `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` |
| Host Property | `Server` | `Host` |
| Auth Properties | Integrated Security | Username/Password |
| DbContext | `UseSqlServer()` | `UseNpgsql()` |
| Service Dependencies | `mssql` | `postgresql` |

---

## ADO.NET Class Replacements

| SQL Server Class | PostgreSQL/Npgsql Class |
|------------------|------------------------|
| `SqlConnection` | `NpgsqlConnection` |
| `SqlCommand` | `NpgsqlCommand` |
| `SqlDataReader` | `NpgsqlDataReader` |
| `SqlParameter` | `NpgsqlParameter` |
| `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` |
| `using Microsoft.Data.SqlClient` | `using Npgsql` |
| `using System.Data.SqlClient` | `using Npgsql` |

---

## Migration Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| `extracted_statements.sql` | `sourceCode/` | Complete catalog of 5 original MS SQL Server statements |
| `converted_statements.sql` | `sourceCode/` | Complete catalog of 5 converted PostgreSQL statements |
| `sql_equivalency_validation_report.json` | `sourceCode/` | Comprehensive equivalency report with all 5 pairs |
| `migration_report.md` | `sourceCode/` | This report |

---

## Build Status

| Build | Result | Errors | Warnings |
|-------|--------|--------|----------|
| Final Build | **SUCCEEDED** | 0 | 192 (pre-existing, unrelated to migration) |

---

## Issues and Caveats

1. **DMS Tool Failures**: All 5 DMS tool calls failed with metadata model creation errors. This is likely due to the migration project configuration not having the source database objects available for analysis. Manual conversion was applied as per the fallback procedure.

2. **SQL Equivalency Tool Errors**: All 5 equivalency validations returned ERROR with `'uniqueID'` error. This appears to be a tool-side issue. The equivalency statuses are recorded exactly as returned by the tool.

3. **Stored Procedure to Function Mapping**: SQL Server's EXEC stored_procedure pattern was converted to PostgreSQL's SELECT * FROM function() pattern. This assumes the stored procedures have been migrated as PostgreSQL functions in the `bobsbookstore_dbo` schema.

4. **Schema Mapping**: The `[dbo]` schema was mapped to `bobsbookstore_dbo` with all object names lowercased, consistent with PostgreSQL conventions.

5. **Parameter Syntax**: SQL Server's named parameters (@ParamName) were converted to PostgreSQL's positional parameters ($N), with NpgsqlParameter objects in C# code.
