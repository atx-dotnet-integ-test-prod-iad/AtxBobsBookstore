# SQL Server to PostgreSQL Migration Report
## BobsBookstore .NET 8.0 Application

**Migration Date:** 2026-03-20  
**Source Database:** Microsoft SQL Server 2019  
**Target Database:** PostgreSQL 13  
**Application Framework:** .NET 8.0 with ADO.NET / Entity Framework Core  
**DMS Migration Project ARN:** arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U

---

## 1. Executive Summary

This report documents the migration of SQL statements in the BobsBookstore .NET 8.0 application from Microsoft SQL Server to PostgreSQL. The migration involved extracting, converting, and re-integrating 5 SQL statements across 2 controller files, along with replacing all SQL Server-specific ADO.NET classes with their PostgreSQL (Npgsql) equivalents.

---

## 2. Migration Statistics

| Metric | Count |
|--------|-------|
| **Total SQL statements processed** | 5 |
| **Statements successfully converted by DMS MCP tool** | 0 |
| **Statements requiring manual conversion (DMS failure)** | 5 |
| **Statements validated as EQUIVALENT by SQL Equivalency tool** | 0 |
| **Statements validated as NOT_EQUIVALENT** | 0 |
| **Statements with equivalency validation ERROR** | 5 |
| **SqlParameter → NpgsqlParameter replacements** | 7 |
| **Files modified** | 2 |

---

## 3. DMS Conversion Results

All 5 SQL statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`). All failed with the same error:

> **Error:** Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.

Per the transformation rules, manual conversion was applied using lowercase schema object names (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA).

---

## 4. SQL Equivalency Validation Results

All 5 statement pairs were validated using the SQL Equivalency tool (`sql-equivalency___validate_sql_equivalence`). All returned ERROR status:

> **Error:** 'uniqueID'

This appears to be a tool configuration/connectivity issue rather than a statement-level problem.

---

## 5. Detailed Statement Conversion Listing

### Statement 1: FindAllAuthorsEmbeddedSql
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Line:** 189 (in FindAllAuthorsEmbeddedSql method)
- **Original SQL (MS SQL):**
  ```sql
  SELECT * FROM bobsbookstore_dbo.author
  ```
- **Converted SQL (PostgreSQL):**
  ```sql
  SELECT * FROM bobsbookstore_dbo.author
  ```
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned 'uniqueID' error)
- **Notes:** Statement was already PostgreSQL-compatible (no SQL Server-specific syntax)

### Statement 2: EditUsingStoredProcedure
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Line:** 166 (in EditUsingStoredProcedure method)
- **Original SQL (MS SQL):**
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **Converted SQL (PostgreSQL):**
  ```sql
  SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned 'uniqueID' error)
- **Changes Applied:**
  - Converted DECLARE/EXEC/SELECT pattern to PostgreSQL `SELECT function()` syntax
  - Schema changed from `[dbo]` to `bobsbookstore_dbo` (PostgreSQL schema mapping)
  - Procedure name lowercased: `uspUpdateAuthorPersonalInfo` → `uspupdateauthorpersonalinfo`
  - 5 SqlParameter → NpgsqlParameter replacements

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Line:** 213 (in DeleteAuthorEmbeddedSql method)
- **Original SQL (MS SQL):**
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **Converted SQL (PostgreSQL):**
  ```sql
  SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
  ```
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned 'uniqueID' error)
- **Changes Applied:**
  - Converted DECLARE/EXEC/SELECT pattern to PostgreSQL `SELECT function()` syntax
  - Schema changed from `[dbo]` to `bobsbookstore_dbo`
  - Procedure name lowercased: `uspDeleteAuthor` → `uspdeleteauthor`
  - 1 SqlParameter → NpgsqlParameter replacement

### Statement 4: SelectAuthorsByHireYear
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Line:** 232 (in SelectAuthorsByHireYear method)
- **Original SQL (MS SQL):**
  ```sql
  SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
  ```
- **Converted SQL (PostgreSQL):**
  ```sql
  SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
  ```
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned 'uniqueID' error)
- **Changes Applied:**
  - `FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss')` → `TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')`
  - `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT`
  - `DATEPART(YEAR, HireDate)` → `EXTRACT(YEAR FROM hiredate)`
  - `GETDATE()` → `NOW()`
  - Column names lowercased: `BusinessEntityID` → `businessentityid`, etc.
  - 1 SqlParameter → NpgsqlParameter replacement

### Statement 5: FindAllProducts
- **Source File:** `app/Bookstore.Web/Controllers/ProductsController.cs`
- **Line:** 38 (in FindAllProducts method)
- **Original SQL (MS SQL):**
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **Converted SQL (PostgreSQL):**
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
  ```
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned 'uniqueID' error)
- **Changes Applied:**
  - Converted `EXEC` to `SELECT * FROM function()` syntax
  - Schema changed from `[dbo]` to `bobsbookstore_dbo`
  - Procedure name lowercased: `uspGetProductData` → `uspgetproductdata`

---

## 6. Code Changes Summary

### SqlParameter → NpgsqlParameter Replacements (7 total)
| File | Method | Parameter | Old Type | New Type |
|------|--------|-----------|----------|----------|
| AuthorsController.cs | EditUsingStoredProcedure | @BusinessEntityID | SqlParameter | NpgsqlParameter |
| AuthorsController.cs | EditUsingStoredProcedure | @NationalIDNumber | SqlParameter | NpgsqlParameter |
| AuthorsController.cs | EditUsingStoredProcedure | @BirthDate | SqlParameter | NpgsqlParameter |
| AuthorsController.cs | EditUsingStoredProcedure | @MaritalStatus | SqlParameter | NpgsqlParameter |
| AuthorsController.cs | EditUsingStoredProcedure | @Gender | SqlParameter | NpgsqlParameter |
| AuthorsController.cs | DeleteAuthorEmbeddedSql | @BusinessEntityID | SqlParameter | NpgsqlParameter |
| AuthorsController.cs | SelectAuthorsByHireYear | @HireDate | SqlParameter | NpgsqlParameter |

### Package References
- **Npgsql.EntityFrameworkCore.PostgreSQL** (v8.0.0) was already present in both Bookstore.Web.csproj and Bookstore.Data.csproj
- **No Microsoft.Data.SqlClient or System.Data.SqlClient** packages were present (project was already partially migrated)
- `using Npgsql;` import was already present in both AuthorsController.cs and ProductsController.cs

### Connection Strings
- Connection strings were already configured for PostgreSQL in the existing codebase
- ApplicationDbContext.cs was already using Npgsql.EntityFrameworkCore.PostgreSQL
- `Npgsql.EnableLegacyTimestampBehavior` was already set to true

---

## 7. Build Verification

| Check | Result |
|-------|--------|
| Build succeeds | ✅ 0 Errors |
| No SqlParameter references remaining | ✅ Verified with grep |
| All SQL statements converted | ✅ 5/5 |
| NpgsqlParameter used for all parameterized queries | ✅ 7/7 |
| `using Npgsql;` present where needed | ✅ Both controllers |

---

## 8. Migration Artifacts

| Artifact | Location | Status |
|----------|----------|--------|
| extracted_statements.sql | Project root (sourceCode/) | ✅ Complete (5 statements) |
| converted_statements.sql | Project root (sourceCode/) | ✅ Complete (5 statements) |
| sql_equivalency_validation_report.json | Project root (sourceCode/) | ✅ Complete (5 entries) |
| dms_conversion_summary.md | Project root (sourceCode/) | ✅ Complete |
| migration_report.md | Project root (sourceCode/) | ✅ This document |

---

## 9. Statements Requiring Further Manual Review

All 5 statements require manual review due to:

1. **DMS Conversion Failure:** All statements failed DMS conversion and were manually converted. Manual conversions should be reviewed for correctness, especially:
   - Stored procedure calls (Statements 2, 3, 5): Verify that the PostgreSQL functions exist with matching signatures
   - Date function conversions (Statement 4): Verify that `EXTRACT(YEAR FROM AGE())` produces equivalent results to `DATEDIFF(YEAR, ...)`

2. **Equivalency Validation Error:** All statements returned ERROR from the SQL Equivalency tool, preventing automated equivalency verification. Manual testing against the actual PostgreSQL database is recommended.

---

## 10. Recommendations

1. **Verify PostgreSQL Functions:** Ensure the following PostgreSQL functions exist in the `bobsbookstore_dbo` schema:
   - `bobsbookstore_dbo.uspupdateauthorpersonalinfo(int, varchar, timestamp, char, char)`
   - `bobsbookstore_dbo.uspdeleteauthor(int)`
   - `bobsbookstore_dbo.uspgetproductdata()`

2. **Integration Testing:** Run the full application against a PostgreSQL database to verify all SQL statements execute correctly.

3. **Date Function Verification:** The `DATEDIFF(YEAR, ...)` to `EXTRACT(YEAR FROM AGE(...))` conversion may produce slightly different results for edge cases near year boundaries. Verify expected behavior.

4. **Performance Testing:** Run queries against the target PostgreSQL database to ensure acceptable performance, particularly for the `SelectAuthorsByHireYear` query with its date extraction logic.
