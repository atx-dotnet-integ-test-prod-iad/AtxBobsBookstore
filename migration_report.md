# Migration Report: Microsoft SQL Server to PostgreSQL

## BobsBookstore .NET ADO Application

---

## 1. Executive Summary

This report documents the migration of the BobsBookstore .NET ADO application from Microsoft SQL Server to PostgreSQL. The migration involved extracting, converting, and re-integrating all SQL statements, replacing SQL Server-specific packages and ADO.NET classes with Npgsql equivalents, and updating connection string configurations.

**Migration Status:** Complete  
**Build Status:** ✅ Successful (0 errors, 184 pre-existing warnings)

---

## 2. SQL Statement Processing Summary

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Statements successfully converted by DMS MCP tool | 0 |
| Statements manually converted (DMS failure) | 5 |
| Statements validated as EQUIVALENT (by SQL Equivalency tool) | 0 |
| Statements validated as NOT_EQUIVALENT (by SQL Equivalency tool) | 0 |
| Statements with EQUIVALENCY ERROR (by SQL Equivalency tool) | 5 |

### DMS Tool Status
All 5 statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`). All 5 failed with the error:
> Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.

Manual conversion was applied using the `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA` method for all 5 statements.

### SQL Equivalency Tool Status
All 5 statement pairs were validated through the SQL Equivalency tool (`sql-equivalency___validate_sql_equivalence`). All 5 returned ERROR status:
> {"equivalence_status": "ERROR", "error": "'uniqueID'"}

**Note:** Equivalency status comes exclusively from the tool output. No agent judgment was used for equivalency determination.

---

## 3. Detailed Statement-by-Statement Report

### Statement 1: EditUsingStoredProcedure

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | EditUsingStoredProcedure |
| **Line** | ~163 |
| **Type** | Stored Procedure Call |

**Original MS SQL:**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
```

| DMS Status | Conversion Method | Equivalency Status |
|------------|-------------------|--------------------|
| FAILED | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |

---

### Statement 2: FindAllAuthorsEmbeddedSql

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | FindAllAuthorsEmbeddedSql |
| **Line** | ~187 |
| **Type** | Simple SELECT Query |

**Original MS SQL:**
```sql
SELECT * FROM [dbo].[Author]
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.author
```

| DMS Status | Conversion Method | Equivalency Status |
|------------|-------------------|--------------------|
| FAILED | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |

---

### Statement 3: DeleteAuthorEmbeddedSql

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | DeleteAuthorEmbeddedSql |
| **Line** | ~207 |
| **Type** | Stored Procedure Call |

**Original MS SQL:**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
```

| DMS Status | Conversion Method | Equivalency Status |
|------------|-------------------|--------------------|
| FAILED | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |

---

### Statement 4: SelectAuthorsByHireYear

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | SelectAuthorsByHireYear |
| **Line** | ~227 |
| **Type** | SELECT with Date Functions and Aggregation |

**Original MS SQL:**
```sql
SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;
```

**Converted PostgreSQL:**
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
```

| DMS Status | Conversion Method | Equivalency Status |
|------------|-------------------|--------------------|
| FAILED | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |

**Conversion Notes:**
- `CONVERT(VARCHAR(19), ModifiedDate, 120)` → `TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')` (date formatting)
- `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(birthdate))::INTEGER` (age calculation)
- `YEAR(HireDate)` → `EXTRACT(YEAR FROM hiredate)` (year extraction)
- All column and table names converted to lowercase for PostgreSQL compatibility

---

### Statement 5: FindAllProducts

| Field | Value |
|-------|-------|
| **Source File** | app/Bookstore.Web/Controllers/ProductsController.cs |
| **Method** | FindAllProducts |
| **Line** | ~34 |
| **Type** | Stored Procedure Call |

**Original MS SQL:**
```sql
EXEC [dbo].[uspGetProductData];
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
```

| DMS Status | Conversion Method | Equivalency Status |
|------------|-------------------|--------------------|
| FAILED | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |

---

## 4. Static Code Changes

### 4.1 Package References
| Package | Status |
|---------|--------|
| Microsoft.Data.SqlClient | Not present (already removed) |
| System.Data.SqlClient | Not present (already removed) |
| Npgsql.EntityFrameworkCore.PostgreSQL (v8.0.10) | ✅ Present in Bookstore.Data.csproj and Bookstore.Web.csproj |

### 4.2 ADO.NET Class Replacements
| SQL Server Class | Npgsql Equivalent | Status |
|------------------|-------------------|--------|
| SqlConnection | NpgsqlConnection | ✅ No SqlConnection references remaining |
| SqlCommand | NpgsqlCommand | ✅ No SqlCommand references remaining |
| SqlDataReader | NpgsqlDataReader | ✅ No SqlDataReader references remaining |
| SqlParameter | NpgsqlParameter | ✅ All parameters use NpgsqlParameter |
| SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder | ✅ Used in ServicesSetup.cs |

### 4.3 Connection String Updates
| Component | Status |
|-----------|--------|
| ServicesSetup.cs UseNpgsql() | ✅ Present |
| NpgsqlConnectionStringBuilder with Host/Port/Database/Username/Password | ✅ Present |
| No Server= SQL Server syntax | ✅ Verified |

### 4.4 Database Context
| Component | Status |
|-----------|--------|
| Npgsql.EnableLegacyTimestampBehavior | ✅ Set to true in ApplicationDbContext |
| Entity mappings with lowercase names | ✅ All entities mapped to lowercase table/column names |
| Schema: bobsbookstore_dbo | ✅ Used consistently across all entity mappings |

### 4.5 Imports/Usings
| File | Import | Status |
|------|--------|--------|
| AuthorsController.cs | using Npgsql; | ✅ Present |
| ProductsController.cs | using Npgsql; | ✅ Present |
| ServicesSetup.cs | using Npgsql; | ✅ Present |
| Any file | using Microsoft.Data.SqlClient; | ✅ Not found |
| Any file | using System.Data.SqlClient; | ✅ Not found |

---

## 5. Statements Requiring Manual Review

All 5 statements require manual review due to:
1. DMS tool failure (metadata model creation error) - manual conversion was applied
2. SQL Equivalency tool returning ERROR for all statement pairs

While the manual conversions follow standard SQL Server → PostgreSQL conversion patterns, they should be verified against the actual PostgreSQL database schema to confirm:
- Function names match the deployed PostgreSQL functions
- Schema name `bobsbookstore_dbo` matches the actual PostgreSQL schema
- Date function conversions produce equivalent results

---

## 6. Build Verification

| Check | Result |
|-------|--------|
| dotnet build BobsBookstore.sln | ✅ Build succeeded |
| Errors | 0 |
| Warnings | 184 (pre-existing CS8618 nullable reference type warnings) |

---

## 7. Migration Artifacts

| Artifact | Location | Status |
|----------|----------|--------|
| Extracted SQL Statements | extracted_statements.sql | ✅ Complete (5 statements) |
| Converted SQL Statements | converted_statements.sql | ✅ Complete (5 statements) |
| SQL Equivalency Report | sql_equivalency_validation_report.json | ✅ Complete (5 entries) |
| Migration Report | migration_report.md | ✅ This document |

---

## 8. Recommendations

1. **DMS Tool Configuration:** Investigate the DMS metadata model creation failure to enable automated SQL conversion in future migrations.
2. **SQL Equivalency Validation:** The `'uniqueID'` error from the SQL Equivalency tool suggests a configuration issue. Once resolved, re-run equivalency validation for all 5 statement pairs.
3. **Integration Testing:** Run the application against a PostgreSQL database to verify all SQL statements execute correctly.
4. **Stored Procedure Verification:** Confirm that the PostgreSQL functions (`uspupdateauthorpersonalinfo`, `uspdeleteauthor`, `uspgetproductdata`) exist in the `bobsbookstore_dbo` schema with the expected signatures.
