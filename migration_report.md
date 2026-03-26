# SQL Server to PostgreSQL Migration Report
## BobsBookstore .NET Application

### Migration Date: 2026-03-26
### Migration Type: Microsoft SQL Server → PostgreSQL (ADO.NET)

---

## 1. Executive Summary

This report documents the migration of the BobsBookstore .NET application from Microsoft SQL Server to PostgreSQL. The migration focused on converting SQL statements embedded in the application code, replacing SQL Server-specific ADO.NET components (SqlParameter) with PostgreSQL equivalents (NpgsqlParameter), and ensuring the application compiles successfully.

---

## 2. SQL Statement Processing Summary

| Metric | Count |
|--------|-------|
| **Total SQL statements processed** | 5 |
| **Successfully converted by DMS MCP tool** | 0 |
| **Requiring manual intervention after DMS failure** | 5 |
| **Validated as equivalent by SQL Equivalency tool** | 0 |
| **Validated as non-equivalent** | 0 |
| **With equivalency validation errors** | 5 |

### DMS Tool Status
All 5 statements were submitted to the DMS MCP tool (dms-mcp___statement_conversion_tool). All returned the same error:
```
Metadata model creation failed: No objects were found according to the specified selection rules.
```
Manual conversion was applied for all statements using lowercase schema object names per migration rules (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA).

### SQL Equivalency Tool Status
All 5 statement pairs were submitted to the SQL Equivalency tool (sql-equivalency___validate_sql_equivalence). All returned ERROR with `'uniqueID'`, indicating a systematic tool configuration issue. Per the transformation rules, all pairs are marked as ERROR (agent judgment was NOT used to determine equivalency).

---

## 3. Detailed Statement Conversions

### Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
| Property | Value |
|----------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | EditUsingStoredProcedure |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool error) |

**Original (T-SQL):**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
```

**Converted (PostgreSQL):**
```sql
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
```

### Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
| Property | Value |
|----------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | FindAllAuthorsEmbeddedSql |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool error) |

**Original (T-SQL):**
```sql
SELECT * FROM Author
```

**Converted (PostgreSQL):**
```sql
SELECT * FROM bobsbookstore_dbo.author
```

### Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
| Property | Value |
|----------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | DeleteAuthorEmbeddedSql |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool error) |

**Original (T-SQL):**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
```

**Converted (PostgreSQL):**
```sql
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
```

### Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
| Property | Value |
|----------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | SelectAuthorsByHireYear |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool error) |

**Original (T-SQL):**
```sql
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
```

**Converted (PostgreSQL):**
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
```

**Function Mappings:**
- `FORMAT()` → `TO_CHAR()`
- `DATEDIFF(YEAR, ...)` → `EXTRACT(YEAR FROM AGE(...))::INT`
- `GETDATE()` → `NOW()`
- `DATEPART(YEAR, ...)` → `EXTRACT(YEAR FROM ...)`

### Statement 5: FindAllProducts (ProductsController.cs)
| Property | Value |
|----------|-------|
| **Source File** | app/Bookstore.Web/Controllers/ProductsController.cs |
| **Method** | FindAllProducts |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR (tool error) |

**Original (T-SQL):**
```sql
EXEC [dbo].[uspGetProductData];
```

**Converted (PostgreSQL):**
```sql
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
```

---

## 4. Code Changes Summary

### Files Modified
| File | Changes |
|------|---------|
| AuthorsController.cs | 4 SQL statements replaced, 7 SqlParameter → NpgsqlParameter, 4 TODO comments removed |
| ProductsController.cs | 1 SQL statement replaced, 1 TODO comment removed |

### SqlParameter → NpgsqlParameter Replacements (7 total)
1. `EditUsingStoredProcedure`: @BusinessEntityID
2. `EditUsingStoredProcedure`: @NationalIDNumber
3. `EditUsingStoredProcedure`: @BirthDate
4. `EditUsingStoredProcedure`: @MaritalStatus
5. `EditUsingStoredProcedure`: @Gender
6. `DeleteAuthorEmbeddedSql`: @BusinessEntityID
7. `SelectAuthorsByHireYear`: @HireDate

---

## 5. Pre-existing Migration (No Changes Required)

The following components were already migrated to PostgreSQL before this transformation:

| Component | Status | Details |
|-----------|--------|---------|
| **Package References** | ✅ Already PostgreSQL | Npgsql.EntityFrameworkCore.PostgreSQL v8.0.10 (no Microsoft.Data.SqlClient present) |
| **ApplicationDbContext.cs** | ✅ Already PostgreSQL | Configured with Npgsql, lowercase column mappings, bobsbookstore_dbo schema |
| **ServicesSetup.cs** | ✅ Already PostgreSQL | Uses UseNpgsql(), NpgsqlConnectionStringBuilder |
| **Connection Strings** | ✅ Already PostgreSQL | PostgreSQL format with Host, Database, Username, Password |
| **Domain Entities** | ✅ Already PostgreSQL | Table/Column attributes with lowercase names and bobsbookstore_dbo schema |
| **using Npgsql;** import | ✅ Already present | Present in both AuthorsController.cs and ProductsController.cs |

---

## 6. Schema Mapping

| SQL Server | PostgreSQL |
|------------|-----------|
| `[dbo]` schema | `bobsbookstore_dbo` schema |
| `Author` table | `bobsbookstore_dbo.author` |
| `Product` table | `bobsbookstore_dbo.product` |
| `[dbo].[uspUpdateAuthorPersonalInfo]` | `bobsbookstore_dbo.uspupdateauthorpersonalinfo()` |
| `[dbo].[uspDeleteAuthor]` | `bobsbookstore_dbo.uspdeleteauthor()` |
| `[dbo].[uspGetProductData]` | `bobsbookstore_dbo.uspgetproductdata()` |
| `BusinessEntityID` | `businessentityid` |
| `ModifiedDate` | `modifieddate` |
| `BirthDate` | `birthdate` |
| `HireDate` | `hiredate` |

---

## 7. Build Verification

| Build | Result |
|-------|--------|
| After Step 3 (AuthorsController.cs changes) | ✅ 0 Errors |
| After Step 4 (ProductsController.cs changes) | ✅ 0 Errors |
| Final build verification | ✅ 0 Errors |

---

## 8. Statements Requiring Manual Review

All 5 statements require manual review due to:
1. **DMS tool failure** - All statements failed DMS conversion and were manually converted
2. **SQL Equivalency tool errors** - All statement pairs returned ERROR from the equivalency tool

**Recommended review actions:**
- Verify stored procedure functions exist in PostgreSQL target database (bobsbookstore_dbo schema)
- Test each SQL statement against actual PostgreSQL database
- Validate that function parameter types match between T-SQL and PostgreSQL versions
- Confirm TO_CHAR/EXTRACT/AGE function behavior matches original FORMAT/DATEDIFF/DATEPART behavior

---

## 9. Migration Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| extracted_statements.sql | sourceCode/ | Catalog of all 5 original T-SQL statements |
| converted_statements.sql | sourceCode/ | Catalog of all 5 converted PostgreSQL statements |
| sql_equivalency_validation_report.json | sourceCode/ | Equivalency validation results for all 5 pairs |
| dms_failure_summary.md | sourceCode/ | Detailed DMS failure documentation |
| migration_report.md | sourceCode/ | This report |
