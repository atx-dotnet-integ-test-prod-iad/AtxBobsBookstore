# BobsBookstore Migration Summary Report
## Microsoft SQL Server to PostgreSQL Migration

---

## 1. Application Overview

| Property | Value |
|---|---|
| **Application** | BobsBookstore |
| **Framework** | .NET 8.0 |
| **Source Database** | Microsoft SQL Server |
| **Target Database** | PostgreSQL |
| **Migration Date** | 2026-03-06 |
| **Build Status** | ✅ SUCCESS (0 errors, 136 pre-existing warnings) |

---

## 2. SQL Statement Conversion Summary

| Metric | Count |
|---|---|
| **Total SQL Statements Processed** | 5 |
| **Successfully Converted by DMS Tool** | 0 |
| **Manually Converted (DMS Failure)** | 5 |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |

### DMS Tool Details
- **Tool**: dms-mcp___statement_conversion_tool
- **Migration Project**: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- **Database**: BobsBookstore
- **Schema**: dbo
- **Region**: us-east-1
- **DMS Error**: All 5 statements failed with: "Metadata model creation failed: The selected objects were not found."

---

## 3. SQL Equivalency Validation Summary

| Metric | Count |
|---|---|
| **Total Pairs Validated** | 5 |
| **Equivalent** | 0 |
| **Non-Equivalent** | 0 |
| **Errors** | 5 |

### Equivalency Tool Details
- **Tool**: sql-equivalency___validate_sql_equivalence
- **Error**: All 5 validations returned ERROR with: `'uniqueID'`
- **Note**: All equivalency statuses come directly from the tool output, not agent judgment.

---

## 4. Detailed Statement Listing

### Statement 1: EditUsingStoredProcedure

| Property | Value |
|---|---|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | EditUsingStoredProcedure |
| **Original MS SQL** | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;` |
| **Converted PostgreSQL** | `SELECT * FROM dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **DMS Attempt Timestamp** | 2026-03-06T01:09:58.908921 |
| **Equivalency Status** | ERROR |
| **Equivalency Tool Output** | `{ "equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-06T01:14:42.490249" }` |

**Manual Conversion Rules Applied:**
- EXEC stored_proc → SELECT * FROM function_name(params)
- DECLARE/SELECT @rowsAffected removed (handled by PostgreSQL function return)
- Schema and object names lowercased

---

### Statement 2: FindAllAuthorsEmbeddedSql

| Property | Value |
|---|---|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | FindAllAuthorsEmbeddedSql |
| **Original MS SQL** | `SELECT * FROM bobsbookstore_dbo.author` |
| **Converted PostgreSQL** | `SELECT * FROM bobsbookstore_dbo.author` |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **DMS Attempt Timestamp** | 2026-03-06T01:10:24.289591 |
| **Equivalency Status** | ERROR |
| **Equivalency Tool Output** | `{ "equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-06T01:14:53.493633" }` |

**Manual Conversion Rules Applied:**
- Statement already uses lowercase schema/table names; no functional changes needed

---

### Statement 3: DeleteAuthorEmbeddedSql

| Property | Value |
|---|---|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | DeleteAuthorEmbeddedSql |
| **Original MS SQL** | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;` |
| **Converted PostgreSQL** | `SELECT * FROM dbo.uspdeleteauthor(@BusinessEntityID);` |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **DMS Attempt Timestamp** | 2026-03-06T01:10:47.870967 |
| **Equivalency Status** | ERROR |
| **Equivalency Tool Output** | `{ "equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-06T01:15:06.927491" }` |

**Manual Conversion Rules Applied:**
- EXEC stored_proc → SELECT * FROM function_name(params)
- DECLARE/SELECT @rowsAffected removed (handled by PostgreSQL function return)
- Schema and object names lowercased

---

### Statement 4: SelectAuthorsByHireYear

| Property | Value |
|---|---|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | SelectAuthorsByHireYear |
| **Original MS SQL** | `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;` |
| **Converted PostgreSQL** | `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;` |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **DMS Attempt Timestamp** | 2026-03-06T01:11:12.576888 |
| **Equivalency Status** | ERROR |
| **Equivalency Tool Output** | `{ "equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-06T01:15:19.714096" }` |

**Manual Conversion Rules Applied:**
- FORMAT(date, 'format') → TO_CHAR(date, 'format') with PostgreSQL format tokens
- DATEDIFF(YEAR, date1, date2) → EXTRACT(YEAR FROM AGE(date2, date1))::INT
- DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
- GETDATE() → NOW()
- All column/table names lowercased

---

### Statement 5: FindAllProducts

| Property | Value |
|---|---|
| **Source File** | app/Bookstore.Web/Controllers/ProductsController.cs |
| **Method** | FindAllProducts |
| **Original MS SQL** | `EXEC [dbo].[uspGetProductData];` |
| **Converted PostgreSQL** | `SELECT * FROM dbo.uspgetproductdata();` |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **DMS Attempt Timestamp** | 2026-03-06T01:11:37.000066 |
| **Equivalency Status** | ERROR |
| **Equivalency Tool Output** | `{ "equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-06T01:15:31.611785" }` |

**Manual Conversion Rules Applied:**
- EXEC stored_proc → SELECT * FROM function_name()
- Schema and object names lowercased

---

## 5. Static Code Changes Summary

### Package Changes

| Original Package | Replaced With |
|---|---|
| Microsoft.Data.SqlClient | Npgsql (via Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0) |
| Microsoft.EntityFrameworkCore.SqlServer | Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 |

### ADO.NET Class Replacements

| SQL Server Class | PostgreSQL (Npgsql) Equivalent |
|---|---|
| SqlConnection | NpgsqlConnection |
| SqlCommand | NpgsqlCommand |
| SqlDataReader | NpgsqlDataReader |
| SqlParameter | NpgsqlParameter |
| SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder |
| UseSqlServer() | UseNpgsql() |

### Connection String Changes

| SQL Server Parameter | PostgreSQL Parameter |
|---|---|
| Data Source / Server | Host |
| Initial Catalog / Database | Database |
| User ID | Username |
| Password | Password |
| Port (default 1433) | Port (default 5432) |

### Files Modified for Static Code Changes
- `app/Bookstore.Web/Bookstore.Web.csproj` - Package references updated
- `app/Bookstore.Data/Bookstore.Data.csproj` - Package references updated
- `app/Bookstore.Web/Controllers/AuthorsController.cs` - SQL statements, NpgsqlParameter usage
- `app/Bookstore.Web/Controllers/ProductsController.cs` - SQL statements, Npgsql import
- `app/Bookstore.Web/Startup/ServicesSetup.cs` - UseNpgsql, NpgsqlConnectionStringBuilder
- `app/Bookstore.Data/ApplicationDbContext.cs` - Npgsql legacy timestamp behavior

---

## 6. Build Status

```
Build: SUCCESS
Errors: 0
Warnings: 136 (all pre-existing CS8618/CS0618 warnings unrelated to migration)
```

---

## 7. Statements Requiring Manual Review

All 5 statements require manual review due to:
1. **DMS Conversion Failure**: All 5 DMS conversion attempts failed with "Metadata model creation failed: The selected objects were not found." Manual conversions were applied.
2. **Equivalency Validation Error**: All 5 equivalency validations returned ERROR from the SQL Equivalency tool with error `'uniqueID'`.

**Recommendation**: Perform runtime testing against the target PostgreSQL database to validate that:
- Stored procedure function calls (statements 1, 3, 5) execute correctly
- SELECT queries (statements 2, 4) return correct results
- Date function conversions (statement 4) produce equivalent output
- Transaction handling maintains atomicity

---

## 8. Transformation Artifacts

| Artifact | Location | Description |
|---|---|---|
| extracted_statements.sql | Project root | All 5 original MS SQL statements with DMS attempt details |
| converted_statements.sql | Project root | All 5 converted PostgreSQL statements with conversion methods |
| sql_equivalency_validation_report.json | Project root | Complete equivalency validation report with all 5 pairs |
| migration_summary_report.md | Project root | This comprehensive migration report |

---

*Report generated: 2026-03-06*
