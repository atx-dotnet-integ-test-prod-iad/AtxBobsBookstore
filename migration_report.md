# BobsBookstore Migration Report
## Microsoft SQL Server to PostgreSQL Migration

**Date:** 2026-03-07  
**Project:** BobsBookstore  
**Source Database:** Microsoft SQL Server 2019 (BobsUsedBookStore)  
**Target Database:** PostgreSQL 13  
**DMS Migration Project:** arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U  

---

## Executive Summary

| Metric | Count |
|--------|-------|
| Total SQL Statements Processed | 5 |
| Successfully Converted by DMS MCP Tool | 5 |
| Requiring Manual Intervention After DMS Failure | 0 |
| Validated as Equivalent (SQL Equivalency Tool) | 0 |
| Validated as Non-Equivalent | 0 |
| Equivalency Validation Errors | 5 |

**Note:** All SQL equivalency validations returned ERROR with `'uniqueID'` error from the SQL Equivalency tool. This appears to be a tool-level service issue rather than a statement-level problem. No agent judgment was used to determine equivalency.

---

## SQL Statement Conversion Details

### Statement 1: EditUsingStoredProcedure
- **Source File:** sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs  
- **Line Number:** 163  
- **Method:** `EditUsingStoredProcedure`  
- **Original MS SQL:**
  ```sql
  EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
  ```
- **Converted PostgreSQL (DMS):**
  ```sql
  CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **DMS Status:** SUCCESS
- **Conversion Method:** DMS_TOOL
- **Key Changes:** `EXEC` → `CALL`, schema `dbo` → `bobsusedbookstore_dbo`, procedure name lowercased
- **Equivalency Status:** ERROR (tool returned: `'uniqueID'`)

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source File:** sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs  
- **Line Number:** 187  
- **Method:** `FindAllAuthorsEmbeddedSql`  
- **Original MS SQL:**
  ```sql
  SELECT * FROM dbo.Author
  ```
- **Converted PostgreSQL (DMS):**
  ```sql
  SELECT * FROM bobsusedbookstore_dbo.author;
  ```
- **DMS Status:** SUCCESS
- **Conversion Method:** DMS_TOOL
- **Key Changes:** Schema `dbo` → `bobsusedbookstore_dbo`, table name lowercased
- **Equivalency Status:** ERROR (tool returned: `'uniqueID'`)

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File:** sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs  
- **Line Number:** 208  
- **Method:** `DeleteAuthorEmbeddedSql`  
- **Original MS SQL:**
  ```sql
  EXEC dbo.uspDeleteAuthor @BusinessEntityID;
  ```
- **Converted PostgreSQL (DMS):**
  ```sql
  CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
  ```
- **DMS Status:** SUCCESS
- **Conversion Method:** DMS_TOOL
- **Key Changes:** `EXEC` → `CALL`, schema `dbo` → `bobsusedbookstore_dbo`, procedure name lowercased
- **Equivalency Status:** ERROR (tool returned: `'uniqueID'`)

### Statement 4: SelectAuthorsByHireYear
- **Source File:** sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs  
- **Line Number:** 228  
- **Method:** `SelectAuthorsByHireYear`  
- **Original MS SQL:**
  ```sql
  SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE YEAR(HireDate) = @HireDate;
  ```
- **Converted PostgreSQL (DMS):**
  ```sql
  SELECT businessentityid, aws_sqlserver_ext.conv_datetime_to_string('VARCHAR(19)', 'DATETIME', modifieddate, 120) AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', birthdate::TIMESTAMP, clock_timestamp()::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;
  ```
- **DMS Status:** SUCCESS
- **Conversion Method:** DMS_TOOL
- **Key Changes:**
  - `CONVERT(VARCHAR(19), ...)` → `aws_sqlserver_ext.conv_datetime_to_string(...)`
  - `DATEDIFF(YEAR, ...)` → `aws_sqlserver_ext.datediff('year', ...)`
  - `GETDATE()` → `clock_timestamp()`
  - `YEAR(HireDate)` → `date_part('year', hiredate)`
  - Column names lowercased
  - Schema `dbo` → `bobsusedbookstore_dbo`
- **Equivalency Status:** ERROR (tool returned: `'uniqueID'`)

### Statement 5: FindAllProducts
- **Source File:** sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs  
- **Line Number:** 34  
- **Method:** `FindAllProducts`  
- **Original MS SQL:**
  ```sql
  EXEC dbo.uspGetProductData;
  ```
- **Converted PostgreSQL (DMS):**
  ```sql
  CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
  ```
- **DMS Status:** SUCCESS
- **Conversion Method:** DMS_TOOL
- **Key Changes:** `EXEC` → `CALL`, schema `dbo` → `bobsusedbookstore_dbo`, procedure name lowercased, cursor parameter added
- **Equivalency Status:** ERROR (tool returned: `'uniqueID'`)

---

## Schema Name Change

**CRITICAL:** The DMS MCP tool converted the schema name from `dbo` to `bobsusedbookstore_dbo`. This reflects the actual PostgreSQL target schema based on the original SQL Server database name `BobsUsedBookStore`. The original code used `bobsbookstore_dbo` as the schema, which was updated to `bobsusedbookstore_dbo` per DMS output.

---

## Static Code Changes Summary

The following static code elements were already migrated to PostgreSQL prior to this transformation:

### Package References (Already Migrated)
- `Npgsql.EntityFrameworkCore.PostgreSQL` Version 8.0.10 in both Bookstore.Data and Bookstore.Web projects
- No `Microsoft.Data.SqlClient` or `System.Data.SqlClient` references present

### ADO.NET Classes (Already Migrated)
- `NpgsqlParameter` used for all parameterized queries
- `NpgsqlConnectionStringBuilder` used for connection string construction
- `UseNpgsql` used for EF Core database context configuration
- No `SqlConnection`, `SqlCommand`, `SqlDataReader`, or `SqlParameter` references present

### Connection String (Already Migrated)
- Uses `NpgsqlConnectionStringBuilder` with PostgreSQL parameters:
  - `Host` (not Server)
  - `Port`
  - `Database`
  - `Username`
  - `Password`

---

## Files Modified During Migration

| File | Changes |
|------|---------|
| `AuthorsController.cs` | 4 SQL statements updated to DMS-converted PostgreSQL versions |
| `ProductsController.cs` | 1 SQL statement updated to DMS-converted PostgreSQL version |

---

## Transformation Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| `extracted_statements.sql` | sourceCode/ | Complete catalog of all 5 original SQL statements |
| `converted_statements.sql` | sourceCode/ | Complete catalog of all 5 DMS-converted SQL statements |
| `sql_equivalency_validation_report.json` | sourceCode/ | JSON report with equivalency validation results for all 5 statement pairs |
| `migration_report.md` | sourceCode/ | This comprehensive migration report |

---

## Build Verification

- **Final Build Status:** SUCCESS
- **Errors:** 0
- **Warnings:** 136 (pre-existing, not related to migration)
- **Build Command:** `dotnet build sourceCode/BobsBookstore.sln`

---

## Notes and Observations

1. **DMS Database Name:** The DMS tool required using `BobsUsedBookStore` as the database name (from the original SQL Server database script `db/bobsusedbooks.sql`), not `BobsBookstore` as specified in the transformation preferences.

2. **Schema Name Transformation:** DMS transformed `dbo` schema to `bobsusedbookstore_dbo` in PostgreSQL, following the DMS convention of prefixing the database name to the schema name.

3. **DMS Extension Functions:** For Statement 4, DMS used `aws_sqlserver_ext` extension functions (`conv_datetime_to_string`, `datediff`) which are part of the AWS SCT extension pack for PostgreSQL. These functions must be installed in the target PostgreSQL database.

4. **Cursor Parameters:** For Statement 5, DMS added a cursor parameter (`par_my_cursor => uspgetproductdata$par_my_cursor`) to the stored procedure call, reflecting the PostgreSQL pattern for returning result sets from stored procedures.

5. **SQL Equivalency Tool:** All 5 equivalency validations returned ERROR with `'uniqueID'`. This is documented as a tool-level issue and no agent judgment was substituted for the tool's output.
