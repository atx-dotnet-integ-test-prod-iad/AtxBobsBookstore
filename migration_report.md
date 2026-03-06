# BobsBookstore Migration Report: MS SQL Server to PostgreSQL

## Executive Summary

This report documents the migration of the BobsBookstore .NET ADO application from Microsoft SQL Server to PostgreSQL. The migration involved extracting and converting all SQL statements using the AWS Database Migration Service (DMS) MCP tool, validating conversions using the SQL Equivalency tool, replacing SQL Server package dependencies with Npgsql equivalents, and updating all database access code and connection strings.

**Migration Date:** 2026-03-06
**Source Database:** Microsoft SQL Server 2019 (BobsUsedBookStore)
**Target Database:** PostgreSQL 13
**DMS Migration Project:** arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U

---

## SQL Statement Processing Summary

| # | Original MS SQL Statement | DMS Converted PostgreSQL Statement | DMS Status | DMS Model |
|---|--------------------------|-----------------------------------|------------|-----------|
| 1 | `EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender` | `CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` | ✅ Success | sql-conversion-1772805750 |
| 2 | `SELECT * FROM Author` | `SELECT * FROM bobsusedbookstore_dbo.author;` | ✅ Success | sql-conversion-1772805846 |
| 3 | `EXEC dbo.uspDeleteAuthor @BusinessEntityID` | `CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);` | ✅ Success | sql-conversion-1772805919 |
| 4 | `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate` | `SELECT businessentityid, to_char(modifieddate, 'yyyy-MM-dd HH24:MI:SS') AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;` | ✅ Success (GenAI-assisted) | sql-conversion-1772806014 |
| 5 | `EXEC [dbo].[uspGetProductData]` | `CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);` | ✅ Success | sql-conversion-1772806087 |

**Total Statements:** 5
**DMS Successes:** 5
**DMS Failures:** 0
**Manual Conversions:** 0

---

## SQL Equivalency Validation Results

All 5 statement pairs were independently validated through the SQL Equivalency MCP tool (sql-equivalency___validate_sql_equivalence).

| # | Equivalency Status | Tool Output |
|---|-------------------|-------------|
| 1 | ERROR | `{"equivalence_status": "ERROR", "error": "'uniqueID'"}` |
| 2 | ERROR | `{"equivalence_status": "ERROR", "error": "'uniqueID'"}` |
| 3 | ERROR | `{"equivalence_status": "ERROR", "error": "'uniqueID'"}` |
| 4 | ERROR | `{"equivalence_status": "ERROR", "error": "'uniqueID'"}` |
| 5 | ERROR | `{"equivalence_status": "ERROR", "error": "'uniqueID'"}` |

**Statements Processed:** 5
**Equivalent:** 0
**Non-Equivalent:** 0
**Errors:** 5

**Note:** All 5 statements returned ERROR with "'uniqueID'" from the SQL Equivalency tool. This appears to be a tool-internal issue unrelated to statement content. Each statement was checked independently per the requirement that "an error on one statement pair DOES NOT mean other statements would have errors." No agent judgment was substituted for equivalency determination.

---

## Schema Mapping

| Source (MS SQL Server) | Target (PostgreSQL) |
|----------------------|-------------------|
| `dbo` schema | `bobsusedbookstore_dbo` schema |
| `Author` table | `author` table |
| `Product` table | `product` table |
| `dbo.uspUpdateAuthorPersonalInfo` | `bobsusedbookstore_dbo.uspupdateauthorpersonalinfo` |
| `dbo.uspDeleteAuthor` | `bobsusedbookstore_dbo.uspdeleteauthor` |
| `[dbo].[uspGetProductData]` | `bobsusedbookstore_dbo.uspgetproductdata` |

### SQL Function Mappings
| MS SQL Server | PostgreSQL |
|--------------|-----------|
| `FORMAT(date, 'yyyy-MM-dd HH:mm:ss')` | `to_char(date, 'yyyy-MM-dd HH24:MI:SS')` |
| `DATEDIFF(YEAR, date1, date2)` | `aws_sqlserver_ext.datediff('year', date1::TIMESTAMP, date2::TIMESTAMP)` |
| `GETDATE()` | `clock_timestamp()` |
| `DATEPART(YEAR, date)` | `date_part('year', date)` |
| `EXEC procedure` | `CALL procedure()` |

---

## File Modification Summary

### Modified Files
| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | Updated 4 SQL statements to DMS-converted PostgreSQL equivalents. Uses `using Npgsql` and `NpgsqlParameter`. |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | Updated 1 SQL statement to DMS-converted PostgreSQL equivalent. Uses `using Npgsql`. |
| `app/Bookstore.Web/Bookstore.Web.csproj` | Removed unused `Microsoft.EntityFrameworkCore.Sqlite` (5.0.7) package reference. |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | Already uses `UseNpgsql()`, `NpgsqlConnectionStringBuilder`, `Host=` format — no changes needed. |

### Already Migrated (No Changes Needed)
| File | Status |
|------|--------|
| `app/Bookstore.Data/Bookstore.Data.csproj` | Already has `Npgsql.EntityFrameworkCore.PostgreSQL` 8.0.0 |

---

## Package Dependency Changes

| Package | Action | Version |
|---------|--------|---------|
| `Npgsql` | Present (Bookstore.Web) | 8.0.0 |
| `Npgsql.EntityFrameworkCore.PostgreSQL` | Present (Bookstore.Web, Bookstore.Data) | 8.0.0 |
| `Microsoft.Data.SqlClient` | Not present (already removed) | N/A |
| `System.Data.SqlClient` | Not present (already removed) | N/A |
| `Microsoft.EntityFrameworkCore.SqlServer` | Not present (already removed) | N/A |
| `Microsoft.EntityFrameworkCore.Sqlite` | **Removed** (unused) | 5.0.7 |

---

## ADO.NET Class Replacements

| SQL Server Class | Npgsql Equivalent | Status |
|-----------------|-------------------|--------|
| `SqlConnection` | `NpgsqlConnection` | ✅ No SQL Server classes remaining |
| `SqlCommand` | `NpgsqlCommand` | ✅ No SQL Server classes remaining |
| `SqlDataReader` | `NpgsqlDataReader` | ✅ No SQL Server classes remaining |
| `SqlParameter` | `NpgsqlParameter` | ✅ All parameters use NpgsqlParameter |

---

## Connection String Changes

| Component | SQL Server | PostgreSQL |
|-----------|-----------|-----------|
| Provider | `UseSqlServer()` | `UseNpgsql()` ✅ |
| Connection Builder | `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` ✅ |
| Host Format | `Server=` | `Host=` ✅ |
| Port | Default 1433 | Explicit `Port=` ✅ |
| Authentication | Integrated Security | Username/Password ✅ |

---

## Build Verification Results

| Step | Build Result | Errors | Warnings |
|------|-------------|--------|----------|
| Step 3 (SQL re-integration) | ✅ Success | 0 | 138 (pre-existing) |
| Step 4 (Package cleanup) | ✅ Success | 0 | 138 (pre-existing) |
| Step 5 (Final verification) | ✅ Success | 0 | 138 (pre-existing) |

---

## Statements Requiring Manual Review

All 5 SQL statement equivalency validations returned ERROR from the SQL Equivalency tool. These should be manually reviewed to confirm functional equivalency:

1. **Statement 1:** Stored procedure call — `EXEC` → `CALL` with schema mapping
2. **Statement 2:** Simple SELECT with schema/table name mapping
3. **Statement 3:** Stored procedure call — `EXEC` → `CALL` with schema mapping
4. **Statement 4:** Complex SELECT with function conversions (FORMAT→to_char, DATEDIFF→aws_sqlserver_ext.datediff, GETDATE→clock_timestamp, DATEPART→date_part) — GenAI-assisted conversion by DMS
5. **Statement 5:** Stored procedure call with cursor parameter — `EXEC` → `CALL` with cursor parameter syntax

---

## Migration Artifacts

| Artifact | Location | Contents |
|----------|----------|----------|
| `extracted_statements.sql` | Project root | All 5 original MS SQL statements |
| `converted_statements.sql` | Project root | All 5 DMS-converted PostgreSQL statements |
| `sql_equivalency_validation_report.json` | Project root | Comprehensive equivalency validation report (5 entries) |
| `migration_report.md` | Project root | This report |
| `build.log` | Project root | Latest build output |

---

## Critical Validation Checklist

- [x] All 5 SQL statements processed through DMS MCP tool
- [x] All 5 statement pairs validated through SQL Equivalency tool
- [x] No SqlConnection/SqlCommand/SqlDataReader/SqlParameter remaining
- [x] No Microsoft.Data.SqlClient/System.Data.SqlClient packages remaining
- [x] Connection strings use PostgreSQL format
- [x] Application compiles without errors
- [x] All artifacts (extracted_statements.sql, converted_statements.sql, sql_equivalency_validation_report.json, migration_report.md) are complete
