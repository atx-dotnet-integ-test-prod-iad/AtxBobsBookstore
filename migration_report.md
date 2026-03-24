# BobsBookstore SQL Server to PostgreSQL Migration Report

## Migration Overview
- **Application**: BobsBookstore .NET ADO Application
- **Source Database**: Microsoft SQL Server 2019
- **Target Database**: PostgreSQL 13
- **Migration Date**: 2026-03-24
- **Framework**: .NET 8.0 with Entity Framework Core 8.0

---

## Static Dependency Migration Status

### Package References ✅ VERIFIED
| Project | Package | Version | Status |
|---------|---------|---------|--------|
| Bookstore.Data.csproj | Npgsql | 8.0.0 | ✅ Present |
| Bookstore.Data.csproj | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | ✅ Present |
| Bookstore.Web.csproj | Npgsql | 8.0.0 | ✅ Present |
| Bookstore.Web.csproj | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | ✅ Present |

**No Microsoft.Data.SqlClient or System.Data.SqlClient references found** ✅

### Using Statements ✅ VERIFIED
| File | Statement | Status |
|------|-----------|--------|
| AuthorsController.cs | `using Npgsql;` | ✅ PostgreSQL |
| ProductsController.cs | `using Npgsql;` | ✅ PostgreSQL |
| ServicesSetup.cs | `using Npgsql;` | ✅ PostgreSQL |

**No SqlClient using statements found** ✅

### ADO.NET Classes ✅ VERIFIED
| SQL Server Class | Npgsql Equivalent | Status |
|-----------------|-------------------|--------|
| SqlParameter | NpgsqlParameter | ✅ All 6 usages use NpgsqlParameter |
| SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder | ✅ Used in ServicesSetup.cs |
| UseSqlServer() | UseNpgsql() | ✅ Used in ServicesSetup.cs |

**No SqlConnection, SqlCommand, SqlDataReader, SqlParameter, or UseSqlServer references found** ✅

### Connection String ✅ VERIFIED
- ServicesSetup.cs uses `NpgsqlConnectionStringBuilder` ✅
- Uses `Host=` format (PostgreSQL) ✅
- Uses `Username`/`Password` properties (PostgreSQL style) ✅
- No SQL Server `Server=` connection string patterns found ✅

---

## SQL Statement Migration Status

### Summary
- **Total SQL Statements**: 5
- **DMS Tool Conversions**: 0 (all failed - metadata model creation error)
- **Manual Conversions**: 5 (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)
- **Equivalency Validations**: 5 attempted, 5 ERROR (tool infrastructure issue)

### Detailed Statement List

#### Statement 1: uspupdateauthorpersonalinfo
- **File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Line**: 163 (EditUsingStoredProcedure method)
- **Original SQL**: `SELECT * FROM dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Converted SQL**: `SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Change**: Removed `dbo.` schema prefix
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

#### Statement 2: Select all authors
- **File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Line**: 187 (FindAllAuthorsEmbeddedSql method)
- **Original SQL**: `SELECT * FROM author`
- **Converted SQL**: `SELECT * FROM author`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Change**: None needed - already PostgreSQL compatible
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

#### Statement 3: uspdeleteauthor
- **File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Line**: 208 (DeleteAuthorEmbeddedSql method)
- **Original SQL**: `SELECT * FROM dbo.uspdeleteauthor(@BusinessEntityID);`
- **Converted SQL**: `SELECT * FROM uspdeleteauthor(@BusinessEntityID);`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Change**: Removed `dbo.` schema prefix
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

#### Statement 4: Complex author age query
- **File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Line**: 228 (SelectAuthorsByHireYear method)
- **Original SQL**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Converted SQL**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Change**: None needed - already uses PostgreSQL-native functions
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

#### Statement 5: uspgetproductdata
- **File**: app/Bookstore.Web/Controllers/ProductsController.cs
- **Line**: 34 (FindAllProducts method)
- **Original SQL**: `SELECT * FROM dbo.uspgetproductdata();`
- **Converted SQL**: `SELECT * FROM uspgetproductdata();`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Change**: Removed `dbo.` schema prefix
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

---

## Codebase Scan Results
- **SqlClient references**: 0 found ✅
- **SqlConnection references**: 0 found ✅
- **SqlCommand references**: 0 found ✅
- **SqlDataReader references**: 0 found ✅
- **SqlParameter references**: 0 found ✅
- **UseSqlServer references**: 0 found ✅
- **dbo. schema prefix references**: 0 found ✅
- **SQL Server connection string patterns**: 0 found ✅

---

## Build Status
- **Final Build**: SUCCESS - 0 errors, 188 warnings (pre-existing, not migration-related)

---

## Migration Artifacts
| File | Description | Status |
|------|-------------|--------|
| extracted_statements.sql | Complete catalog of original SQL statements | ✅ Complete (5 statements) |
| converted_statements.sql | Complete catalog of converted SQL statements | ✅ Complete (5 statements) |
| sql_equivalency_validation_report.json | Equivalency validation report | ✅ Complete (5 entries) |
| dms_conversion_log.md | DMS conversion interaction log | ✅ Complete |
| migration_report.md | This report | ✅ Complete |
