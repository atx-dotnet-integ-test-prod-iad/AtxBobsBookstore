# SQL Server to PostgreSQL Migration Report

## Migration Summary

**Project:** BobsBookstore .NET ADO Application
**Migration Type:** Microsoft SQL Server → PostgreSQL
**Date:** 2026-03-06
**Last Updated:** 2026-03-06T13:55:00
**Status:** Completed with DMS and Equivalency Tool Errors (documented)
**Build Status:** SUCCESS (0 Errors)

---

## 1. SQL Statements Processed

### Total: 12 SQL Statements

| Source File | Statement Count | Statement Types |
|---|---|---|
| AuthorsController.cs | 4 | Stored procedure calls (EXEC), SELECT with SQL Server functions |
| ProductsController.cs | 1 | Stored procedure call (EXEC) |
| db/bobsusedbooks.sql | 3 | CREATE TABLE, CREATE VIEW, CREATE FUNCTION |
| db/adven.sql | 3 | CREATE TABLE, ALTER TABLE, CREATE PROCEDURE |
| db/adven-data.sql | 1 | INSERT INTO |

### Statement Details:

1. **EditUsingStoredProcedure** (AuthorsController.cs) - DECLARE/EXEC stored procedure → SELECT FROM function
2. **FindAllAuthorsEmbeddedSql** (AuthorsController.cs) - SELECT * FROM table (already compatible)
3. **DeleteAuthorEmbeddedSql** (AuthorsController.cs) - DECLARE/EXEC stored procedure → SELECT FROM function
4. **SelectAuthorsByHireYear** (AuthorsController.cs) - FORMAT/DATEDIFF/GETDATE/DATEPART → TO_CHAR/EXTRACT/AGE/NOW
5. **FindAllProducts** (ProductsController.cs) - EXEC stored procedure → SELECT FROM function
6. **CREATE TABLE Members** (bobsusedbooks.sql) - IDENTITY/nvarchar/datetime → GENERATED ALWAYS AS IDENTITY/varchar/timestamp
7. **CREATE VIEW VwTopMembers** (bobsusedbooks.sql) - Bracket removal, schema conversion
8. **CREATE FUNCTION ufnGetAccountingEndDate** (bobsusedbooks.sql) - DATEADD/CONVERT → INTERVAL/CAST
9. **CREATE TABLE Author** (adven.sql) - Full DDL conversion with type mapping
10. **ALTER TABLE Author ADD CONSTRAINT** (adven.sql) - dateadd → INTERVAL expression
11. **CREATE PROCEDURE uspGetProductData** (adven.sql) - Stored procedure → PostgreSQL function
12. **INSERT INTO Author** (adven-data.sql) - Bracket removal, N-prefix removal

---

## 2. DMS Conversion Results

| Metric | Count |
|---|---|
| Total statements sent to DMS | 12 |
| Successfully converted by DMS | 0 |
| Failed DMS conversion | 12 |
| Manual conversion required | 12 |

**DMS Error:** All 12 statements failed with the same error:
```
Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
```

**Manual Conversion Method:** `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`
- All schema object names converted to lowercase for PostgreSQL compatibility
- SQL Server-specific functions converted to PostgreSQL equivalents
- Data types mapped to PostgreSQL equivalents

---

## 3. SQL Equivalency Validation Results

| Metric | Count |
|---|---|
| Total statement pairs validated | 12 |
| EQUIVALENT | 0 |
| NOT_EQUIVALENT | 0 |
| ERROR | 12 |

**Equivalency Tool Error:** All 12 statement pairs returned ERROR:
```json
{"equivalence_status": "ERROR", "error": "'uniqueID'"}
```

**Note:** The SQL Equivalency tool (sql-equivalency___validate_sql_equivalence) returned a consistent `'uniqueID'` error for all statement pairs. This appears to be a tool configuration issue, not a statement-specific problem. As per the transformation definition requirements, these are marked as ERROR and NOT determined by agent judgment.

---

## 4. C# Code Changes

### SqlParameter → NpgsqlParameter (AuthorsController.cs)
- 7 instances of `new SqlParameter(...)` replaced with `new NpgsqlParameter(...)`
- `using Npgsql;` import was already present
- Affected methods:
  - EditUsingStoredProcedure: 5 parameters
  - DeleteAuthorEmbeddedSql: 1 parameter
  - SelectAuthorsByHireYear: 1 parameter

### SQL Statement Replacements
- AuthorsController.cs: 4 SQL strings replaced with PostgreSQL equivalents
- ProductsController.cs: 1 SQL string replaced with PostgreSQL equivalent

---

## 5. Connection String Status

The application's connection string (in `appsettings.json`) already uses PostgreSQL format:
```json
"ConnectionStrings": {
  "Default": "Host=...;Database=...;Username=...;Password=..."
}
```
**No changes required.**

---

## 6. Entity Framework Core Provider Status

The project already uses the Npgsql EF Core provider:
```xml
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="8.0.0" />
```
The `ServicesSetup.cs` already configures `UseNpgsql()`.
**No changes required.**

---

## 7. Database Script Conversions (db/ directory)

### adven.sql (4,341 lines)
Comprehensive conversion applied:
- Removed USE/GO statements
- Removed COLLATE clauses
- Converted data types (nvarchar→varchar, nchar→char, datetime→timestamp, bit→boolean, etc.)
- Converted IDENTITY to GENERATED ALWAYS AS IDENTITY
- Converted getdate()/GETDATE() to NOW()
- Removed bracket identifiers
- Converted dateadd to INTERVAL expressions
- Converted stored procedures syntax

### bobsusedbooks.sql (5,878 lines)
Comprehensive conversion applied:
- Same patterns as adven.sql
- Additionally: CREATE DATABASE/ALTER DATABASE commented out
- SET IDENTITY_INSERT commented out
- money/smallmoney → numeric types

### adven-data.sql (2,977 lines)
Data statements conversion:
- Removed USE/GO, brackets, N-prefix
- SET IDENTITY_INSERT commented out

---

## 8. Build Verification

**Final Build Status:** ✅ SUCCESS
- 0 Errors
- 136 Warnings (all pre-existing CS8618 nullable reference type warnings)

---

## 9. Statements Requiring Manual Review

All 12 statements require manual review due to:
1. DMS tool failure (unable to verify conversion accuracy via DMS)
2. SQL Equivalency tool error (unable to validate equivalency via tool)

The manual conversions follow standard SQL Server → PostgreSQL migration patterns and should be functionally equivalent, but could not be verified by the automated tools.

---

## 10. Migration Artifacts

| Artifact | Location | Description |
|---|---|---|
| extracted_statements.sql | sourceCode/ | Complete catalog of all 12 original MS SQL statements |
| converted_statements.sql | sourceCode/ | Complete catalog of all 12 converted PostgreSQL statements |
| sql_equivalency_validation_report.json | sourceCode/ | Comprehensive JSON report with all statement pairs and tool results |
| migration_report.md | sourceCode/ | This report |
