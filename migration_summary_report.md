# BobsBookstore - SQL Server to PostgreSQL Migration Summary Report

**Date:** 2026-03-22  
**Migration Type:** Microsoft SQL Server → PostgreSQL  
**Application:** BobsBookstore .NET ADO Application  
**Framework:** .NET 8.0, Entity Framework Core 8.0  

---

## 1. SQL Statement Processing Summary

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| DMS tool conversion attempts | 5 |
| DMS tool successful conversions | 0 |
| Manual conversions (DMS failure) | 5 |
| SQL Equivalency validations performed | 5 |
| Equivalency status: EQUIVALENT | 0 |
| Equivalency status: NOT_EQUIVALENT | 0 |
| Equivalency status: ERROR | 5 |

### DMS Tool Failure Details
All 5 SQL statements were submitted to the AWS DMS MCP Statement Conversion Tool (`dms-mcp___statement_conversion_tool`) with the following parameters:
- **Migration Project ARN:** `arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U`
- **Schema Name:** `dbo`
- **Region:** `us-east-1`

All 5 failed with the same error:
```
Metadata model creation failed: {'error': "Metadata model creation failed: 
{'default_error_details': {'message': 'No objects were found according to the 
specified selection rules. Please review your selection rules and try again.'}}"}
```

### Manual Conversion Applied
Since DMS failed for all statements, manual conversion was applied using **DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA** rules:
- All schema object names (tables, columns, stored procedures) converted to lowercase
- SQL Server EXEC/DECLARE syntax converted to PostgreSQL SELECT function call syntax
- Schema prefix `bobsbookstore_dbo` retained as-is (already lowercase)

### SQL Equivalency Tool Results
All 5 statement pairs were submitted to the SQL Equivalency validation tool (`sql-equivalency___validate_sql_equivalence`). All returned ERROR status with error `'uniqueID'`. Per transformation rules, these are marked as ERROR (no agent judgment applied).

---

## 2. Statement Conversion Details

### Statement 1: FindAllAuthorsEmbeddedSql
- **Source:** AuthorsController.cs, FindAllAuthorsEmbeddedSql method
- **Original MSSQL:** `SELECT * FROM bobsbookstore_dbo.Author`
- **Converted PostgreSQL:** `SELECT * FROM bobsbookstore_dbo.author`
- **DMS Status:** FAILED
- **Equivalency Status:** ERROR (tool returned `'uniqueID'`)
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Changes Applied:** Lowercase table name

### Statement 2: EditUsingStoredProcedure
- **Source:** AuthorsController.cs, EditUsingStoredProcedure method
- **Original MSSQL:** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [bobsbookstore_dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Converted PostgreSQL:** `SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **DMS Status:** FAILED
- **Equivalency Status:** ERROR (tool returned `'uniqueID'`)
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Changes Applied:** DECLARE/EXEC → SELECT function call, lowercase function name

### Statement 3: DeleteAuthorEmbeddedSql
- **Source:** AuthorsController.cs, DeleteAuthorEmbeddedSql method
- **Original MSSQL:** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [bobsbookstore_dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Converted PostgreSQL:** `SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **DMS Status:** FAILED
- **Equivalency Status:** ERROR (tool returned `'uniqueID'`)
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Changes Applied:** DECLARE/EXEC → SELECT function call, lowercase function name

### Statement 4: SelectAuthorsByHireYear
- **Source:** AuthorsController.cs, SelectAuthorsByHireYear method
- **Original MSSQL:** `SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.Author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;`
- **Converted PostgreSQL:** `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **DMS Status:** FAILED
- **Equivalency Status:** ERROR (tool returned `'uniqueID'`)
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Changes Applied:** Lowercase column names, table name, and aliases

### Statement 5: FindAllProducts
- **Source:** ProductsController.cs, FindAllProducts method
- **Original MSSQL:** `EXEC [bobsbookstore_dbo].[uspGetProductData];`
- **Converted PostgreSQL:** `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **DMS Status:** FAILED
- **Equivalency Status:** ERROR (tool returned `'uniqueID'`)
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Changes Applied:** EXEC → SELECT * FROM function call, lowercase function name

---

## 3. Static Code Verification Summary

### Package References

| Project | Package | Status |
|---------|---------|--------|
| Bookstore.Data.csproj | Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ Present |
| Bookstore.Web.csproj | Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ Present |
| All .csproj files | Microsoft.Data.SqlClient | ✅ Not present (removed) |
| All .csproj files | System.Data.SqlClient | ✅ Not present (removed) |
| All .csproj files | Microsoft.EntityFrameworkCore.SqlServer | ✅ Not present (removed) |

### Using Statements/Imports

| File | Import | Status |
|------|--------|--------|
| AuthorsController.cs | `using Npgsql;` | ✅ Present |
| ProductsController.cs | `using Npgsql;` | ✅ Present |
| ServicesSetup.cs | `using Npgsql;` | ✅ Present |
| All .cs files | `using Microsoft.Data.SqlClient;` | ✅ Not present (removed) |
| All .cs files | `using System.Data.SqlClient;` | ✅ Not present (removed) |

### ADO.NET Class Replacements

| SQL Server Class | Npgsql Equivalent | Status |
|-----------------|-------------------|--------|
| SqlConnection | NpgsqlConnection | ✅ No SqlConnection references remain |
| SqlCommand | NpgsqlCommand | ✅ No SqlCommand references remain |
| SqlDataReader | NpgsqlDataReader | ✅ No SqlDataReader references remain |
| SqlParameter | NpgsqlParameter | ✅ All 7 occurrences use NpgsqlParameter |
| SqlTransaction | NpgsqlTransaction | ✅ No SqlTransaction references remain |
| SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder | ✅ ServicesSetup.cs uses NpgsqlConnectionStringBuilder |

### Connection Strings

| Configuration Item | Status |
|-------------------|--------|
| Connection string format | ✅ PostgreSQL (Host/Port/Database/Username/Password) |
| NpgsqlConnectionStringBuilder | ✅ Used in ServicesSetup.cs |
| UseNpgsql() in DbContext | ✅ Used in ServicesSetup.cs |
| Npgsql.EnableLegacyTimestampBehavior | ✅ Set in ApplicationDbContext.cs |
| UseSqlServer() | ✅ Not present (removed) |

### DbContext Configuration

| Configuration Item | Status |
|-------------------|--------|
| Entity table mappings use lowercase names | ✅ All entities use lowercase table/column names |
| Schema prefix `bobsbookstore_dbo` | ✅ Applied to all entity mappings |
| Npgsql.EnableLegacyTimestampBehavior | ✅ Enabled in static constructor |

---

## 4. Codebase Scan Results - SQL Server Artifact Check

| Search Pattern | Occurrences Found |
|---------------|-------------------|
| `SqlConnection` | 0 |
| `SqlCommand` | 0 |
| `SqlDataReader` | 0 |
| `SqlParameter` | 0 |
| `SqlTransaction` | 0 |
| `Microsoft.Data.SqlClient` | 0 |
| `System.Data.SqlClient` | 0 |
| `UseSqlServer` | 0 |
| `SqlConnectionStringBuilder` | 0 |
| `Microsoft.EntityFrameworkCore.SqlServer` | 0 |

**Result:** ✅ No SQL Server artifacts remain in the codebase.

---

## 5. Files Modified During Migration

| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | 4 SQL statements converted to PostgreSQL, SqlParameter → NpgsqlParameter (7 occurrences), using statement updated |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | 1 SQL statement converted to PostgreSQL, using statement updated |
| `app/Bookstore.Data/Bookstore.Data.csproj` | Npgsql.EntityFrameworkCore.PostgreSQL package reference present |
| `app/Bookstore.Web/Bookstore.Web.csproj` | Npgsql.EntityFrameworkCore.PostgreSQL package reference present |
| `app/Bookstore.Data/ApplicationDbContext.cs` | Lowercase table/column mappings, Npgsql.EnableLegacyTimestampBehavior |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | NpgsqlConnectionStringBuilder, UseNpgsql(), using Npgsql |

---

## 6. Build Status

- **Final Build:** ✅ Success (0 errors, 156 warnings — all pre-existing Magick.NET vulnerability warnings)
- **Solution:** BobsBookstore.sln
- **Target Framework:** net8.0

---

## 7. Transformation Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| `extracted_statements.sql` | Project root | Catalog of all 5 original MS SQL statements |
| `converted_statements.sql` | Project root | Catalog of all 5 converted PostgreSQL statements |
| `sql_equivalency_validation_report.json` | Project root | Comprehensive equivalency report with all 5 statement pairs |
| `migration_summary_report.md` | Project root | This report |

---

## 8. Remaining Action Items

1. **DMS Tool Investigation:** All DMS conversions failed due to metadata model creation issues. The migration project may need to be re-configured or the source database schema objects may need to be loaded into the DMS project.

2. **SQL Equivalency Validation:** All equivalency checks returned ERROR with `'uniqueID'` from the tool. The converted statements should be manually reviewed and tested against the PostgreSQL database to confirm functional equivalence.

3. **Stored Procedure Migration:** The PostgreSQL database must have the following functions created:
   - `bobsbookstore_dbo.uspupdateauthorpersonalinfo()`
   - `bobsbookstore_dbo.uspdeleteauthor()`
   - `bobsbookstore_dbo.uspgetproductdata()`

4. **Integration Testing:** End-to-end testing against the PostgreSQL database should be performed to verify all database operations work correctly.
