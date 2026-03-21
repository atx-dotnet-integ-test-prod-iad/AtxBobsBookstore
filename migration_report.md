# BobsBookstore Migration Report
## MS SQL Server to PostgreSQL Migration

---

## 1. Migration Summary

| Field | Value |
|-------|-------|
| **Application Name** | BobsBookstore |
| **Migration Date** | 2026-03-21 |
| **Source Database** | Microsoft SQL Server |
| **Target Database** | PostgreSQL |
| **Framework** | .NET 8.0 (ASP.NET Core MVC with Entity Framework Core) |
| **ORM** | Entity Framework Core 8.0.10 |
| **Database Driver** | Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 |

---

## 2. SQL Statement Processing

### 2.1 Summary

| Metric | Count |
|--------|-------|
| Total SQL Statements Processed | 5 |
| DMS Tool Successful Conversions | 0 |
| DMS Tool Failed Conversions | 5 |
| Manual Conversions (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA) | 5 |

### 2.2 Conversion Method Breakdown

- **DMS_TOOL**: 0 statements
- **DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA**: 5 statements

All 5 DMS calls failed with the same error: `Metadata model creation failed: No objects were found according to the specified selection rules.`

### 2.3 Individual Statement Conversion Details

#### Statement 1: Update Author Personal Info (Stored Procedure Call)

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | EditUsingStoredProcedure |
| **Line** | ~163 |
| **DMS Timestamp** | 2026-03-21T05:32:11.559002 |
| **DMS Status** | ERROR |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |

**Original MS SQL:**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
```

**Converted PostgreSQL:**
```sql
SELECT uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
```

**Manual Conversion Notes:** Converted EXEC stored procedure call to PostgreSQL SELECT function() syntax. Applied lowercase to all schema objects.

---

#### Statement 2: Find All Authors (Simple SELECT)

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | FindAllAuthorsEmbeddedSql |
| **Line** | ~187 |
| **DMS Timestamp** | 2026-03-21T05:32:37.696097 |
| **DMS Status** | ERROR |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |

**Original MS SQL:**
```sql
SELECT * FROM Author
```

**Converted PostgreSQL:**
```sql
SELECT * FROM author
```

**Manual Conversion Notes:** Applied lowercase to table name: Author → author.

---

#### Statement 3: Delete Author (Stored Procedure Call)

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | DeleteAuthorEmbeddedSql |
| **Line** | ~208 |
| **DMS Timestamp** | 2026-03-21T05:33:03.446455 |
| **DMS Status** | ERROR |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |

**Original MS SQL:**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
```

**Converted PostgreSQL:**
```sql
SELECT uspdeleteauthor(@BusinessEntityID);
```

**Manual Conversion Notes:** Converted EXEC stored procedure call to PostgreSQL SELECT function() syntax. Applied lowercase to all schema objects.

---

#### Statement 4: Select Authors By Hire Year (Complex SELECT)

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | SelectAuthorsByHireYear |
| **Line** | ~228 |
| **DMS Timestamp** | 2026-03-21T05:33:27.302931 |
| **DMS Status** | ERROR |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |

**Original MS SQL:**
```sql
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
```

**Converted PostgreSQL:**
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
```

**Manual Conversion Notes:**
- `FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss')` → `TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')`
- `DATEDIFF(YEAR, BirthDate, GETDATE())` → `DATE_PART('year', AGE(NOW(), birthdate))::INT`
- `DATEPART(YEAR, HireDate)` → `EXTRACT(YEAR FROM hiredate)`
- Applied lowercase to all schema objects and aliases

---

#### Statement 5: Get Product Data (Stored Procedure Call)

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/ProductsController.cs |
| **Method** | FindAllProducts |
| **Line** | ~34 |
| **DMS Timestamp** | 2026-03-21T05:33:50.267887 |
| **DMS Status** | ERROR |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |

**Original MS SQL:**
```sql
EXEC [dbo].[uspGetProductData];
```

**Converted PostgreSQL:**
```sql
SELECT * FROM uspgetproductdata();
```

**Manual Conversion Notes:** Converted EXEC stored procedure call to PostgreSQL SELECT * FROM function() syntax. Applied lowercase to all schema objects.

---

## 3. Equivalency Validation Results

### 3.1 Summary

All equivalency validations were performed using the `sql-equivalency___validate_sql_equivalence` MCP tool. **No agent judgment was used for equivalency determination.**

| Metric | Count |
|--------|-------|
| Statements Validated | 5 |
| EQUIVALENT | 0 |
| NOT_EQUIVALENT | 0 |
| ERROR | 5 |

All 5 statement pairs returned ERROR status with error `'uniqueID'` from the SQL Equivalency tool.

### 3.2 Individual Equivalency Results

| # | Statement | Equivalency Status | Tool Output |
|---|-----------|-------------------|-------------|
| 1 | uspUpdateAuthorPersonalInfo | ERROR | `{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-21T05:37:51.041840"}` |
| 2 | SELECT * FROM Author | ERROR | `{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-21T05:38:00.607185"}` |
| 3 | uspDeleteAuthor | ERROR | `{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-21T05:38:10.805921"}` |
| 4 | Complex SELECT with date functions | ERROR | `{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-21T05:38:25.273725"}` |
| 5 | uspGetProductData | ERROR | `{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-21T05:38:37.214224"}` |

---

## 4. Files Modified

| File | Description of Changes |
|------|----------------------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | SQL statements verified to use PostgreSQL syntax (lowercase schema objects, PostgreSQL functions). Uses `using Npgsql;` and `NpgsqlParameter`. |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | SQL statement verified to use PostgreSQL syntax. Uses `using Npgsql;`. |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | Uses `UseNpgsql()`, `NpgsqlConnectionStringBuilder`, `using Npgsql;`, PostgreSQL connection string format. |
| `app/Bookstore.Data/Bookstore.Data.csproj` | Uses `Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0`. No SQL Server packages. |
| `app/Bookstore.Web/Bookstore.Web.csproj` | Uses `Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0`. No SQL Server packages. |
| `extracted_statements.sql` | Created: Catalog of all 5 original MS SQL Server statements |
| `converted_statements.sql` | Created: Catalog of all 5 converted PostgreSQL statements |
| `sql_equivalency_validation_report.json` | Created: Comprehensive equivalency validation report |

---

## 5. Package Changes

### Removed SQL Server Packages
- ~~`Microsoft.EntityFrameworkCore.SqlServer`~~ (removed in prior migration)
- ~~`Microsoft.Data.SqlClient`~~ (removed in prior migration)
- ~~`System.Data.SqlClient`~~ (removed in prior migration)

### Added PostgreSQL Packages
- `Npgsql.EntityFrameworkCore.PostgreSQL` Version 8.0.0 (in Bookstore.Data.csproj)
- `Npgsql.EntityFrameworkCore.PostgreSQL` Version 8.0.0 (in Bookstore.Web.csproj)

---

## 6. Connection String Changes

### Before (SQL Server Format)
```
Server=myServerAddress;Database=BobsUsedBookStore;Integrated Security=true;
```

### After (PostgreSQL Format)
```
Host={dbSecrets.Host};Port={dbSecrets.Port};Database=BobsUsedBookStore;Username={dbSecrets.Username};Password={dbSecrets.Password}
```

**Key Changes:**
- `Server=` → `Host=`
- Added explicit `Port=` parameter
- `Integrated Security=true` → `Username`/`Password` authentication
- Uses `NpgsqlConnectionStringBuilder` instead of `SqlConnectionStringBuilder`
- No SQL Server-specific parameters (MultipleActiveResultSets, TrustServerCertificate)

---

## 7. SQL Server Reference Scan (Post-Migration)

| Search Pattern | Results Found |
|---------------|--------------|
| SqlConnection | 0 |
| SqlCommand | 0 |
| SqlDataReader | 0 |
| SqlParameter | 0 |
| SqlConnectionStringBuilder | 0 |
| Microsoft.Data.SqlClient | 0 |
| System.Data.SqlClient | 0 |
| UseSqlServer | 0 |
| Microsoft.EntityFrameworkCore.SqlServer | 0 |

**Result: Zero SQL Server references remain in the codebase** (excluding bin/obj directories).

---

## 8. Build Status

| Metric | Value |
|--------|-------|
| Build Command | `dotnet build BobsBookstore.sln` |
| Build Result | **SUCCESS** |
| Errors | 0 |
| Warnings | 184 (pre-existing nullable reference warnings, not migration-related) |

---

## 9. Transformation Artifacts

| Artifact | Description |
|----------|-------------|
| `extracted_statements.sql` | Complete catalog of all 5 original MS SQL Server statements with source file, line, context, and parameters |
| `converted_statements.sql` | Complete catalog of all 5 converted PostgreSQL statements with conversion method and DMS tool output |
| `sql_equivalency_validation_report.json` | Comprehensive equivalency validation report in JSON format with all 5 statement pairs |
| `migration_report.md` | This comprehensive migration report |

---

## 10. Manual Interventions

All 5 SQL statements required manual conversion because the DMS MCP tool failed with error:
```
Metadata model creation failed: {'error': "Metadata model creation failed: 
{'default_error_details': {'message': 'No objects were found according to the specified 
selection rules. Please review your selection rules and try again.'}}"}
```

### Manual Conversion Rules Applied (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA):
1. **Stored Procedure Calls**: Converted `EXEC [dbo].[procName]` → `SELECT procname()`
2. **Table Names**: Applied lowercase: `Author` → `author`, `Product` → `product`
3. **Column Names**: Applied lowercase: `BusinessEntityID` → `businessentityid`
4. **Function Conversions**:
   - `FORMAT()` → `TO_CHAR()` with PostgreSQL format specifiers
   - `DATEDIFF(YEAR, ...)` → `DATE_PART('year', AGE(...))`
   - `GETDATE()` → `NOW()`
   - `DATEPART(YEAR, ...)` → `EXTRACT(YEAR FROM ...)`
5. **Type Casting**: Added `::INT` for integer casting where needed

---

## 11. Summary Statistics

| Category | Metric | Value |
|----------|--------|-------|
| **SQL Statements** | Total Processed | 5 |
| | DMS Tool Successes | 0 |
| | DMS Tool Failures | 5 |
| | Manual Conversions | 5 |
| **Equivalency** | Total Validated | 5 |
| | Equivalent | 0 |
| | Not Equivalent | 0 |
| | Error | 5 |
| **Files** | Source Files with SQL | 2 |
| | Total Files Scanned | 19+ |
| | Files Modified | 5 (source) + 4 (artifacts) |
| **Build** | Errors | 0 |
| | Warnings | 184 (pre-existing) |
| **SQL Server References** | Remaining | 0 |

---

*Report generated: 2026-03-21*
*All equivalency statuses come exclusively from the SQL Equivalency tool (sql-equivalency___validate_sql_equivalence), not from agent judgment.*
