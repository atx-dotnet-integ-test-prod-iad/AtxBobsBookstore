# Final Migration Report: SQL Server to PostgreSQL
## BobsBookstore .NET ADO Application

**Report Date**: 2026-03-26  
**Migration Type**: Microsoft SQL Server → PostgreSQL  
**Application Framework**: .NET 8.0 with Entity Framework Core  
**Database Access Pattern**: ADO.NET (EF Core + Raw SQL)

---

## Executive Summary

The BobsBookstore .NET application was migrated from Microsoft SQL Server to PostgreSQL. All SQL statements were extracted, converted, and re-integrated. The DMS MCP tool was used for conversion attempts (all failed with metadata model creation errors), and manual conversion was applied using lowercase schema mapping conventions. The SQL Equivalency validation tool returned ERROR status for all 5 statement pairs due to a consistent tool-level error.

---

## SQL Statement Processing Summary

| Metric | Count |
|---|---|
| **Total SQL Statements Processed** | 5 |
| **Successfully Converted by DMS MCP Tool** | 0 |
| **Manual Conversion Applied (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)** | 5 |
| **Validated as Equivalent (by SQL Equivalency Tool)** | 0 |
| **Validated as Non-Equivalent (by SQL Equivalency Tool)** | 0 |
| **Equivalency Validation Errors (from SQL Equivalency Tool)** | 5 |

---

## Detailed SQL Statement Conversions

### Statement 1: EditUsingStoredProcedure
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: `EditUsingStoredProcedure()`
- **Original MS SQL**: 
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **Converted PostgreSQL**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed (attempted 3 times)
- **Equivalency Status**: ERROR (from sql-equivalency tool, error: 'uniqueID')

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: `FindAllAuthorsEmbeddedSql()`
- **Original MS SQL**: 
  ```sql
  SELECT * FROM [dbo].[Author]
  ```
- **Converted PostgreSQL**:
  ```sql
  SELECT * FROM bobsbookstore_dbo."author"
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed (attempted 3 times)
- **Equivalency Status**: ERROR (from sql-equivalency tool, error: 'uniqueID')

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: `DeleteAuthorEmbeddedSql()`
- **Original MS SQL**: 
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **Converted PostgreSQL**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed (attempted 3 times)
- **Equivalency Status**: ERROR (from sql-equivalency tool, error: 'uniqueID')

### Statement 4: SelectAuthorsByHireYear
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: `SelectAuthorsByHireYear()`
- **Original MS SQL**: 
  ```sql
  SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;
  ```
- **Converted PostgreSQL**:
  ```sql
  SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, birthdate))::integer AS age FROM bobsbookstore_dbo."author" WHERE DATE_PART('year', hiredate) = @HireDate;
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed (attempted 3 times)
- **Equivalency Status**: ERROR (from sql-equivalency tool, error: 'uniqueID')
- **Conversion Details**:
  - `CONVERT(VARCHAR, ModifiedDate, 120)` → `TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')`
  - `DATEDIFF(YEAR, BirthDate, GETDATE())` → `DATE_PART('year', AGE(CURRENT_TIMESTAMP, birthdate))::integer`
  - `YEAR(HireDate)` → `DATE_PART('year', hiredate)`
  - All column/table names lowercased

### Statement 5: FindAllProducts
- **Source File**: app/Bookstore.Web/Controllers/ProductsController.cs
- **Method**: `FindAllProducts()`
- **Original MS SQL**: 
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **Converted PostgreSQL**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed (attempted 3 times)
- **Equivalency Status**: ERROR (from sql-equivalency tool, error: 'uniqueID')

---

## Static Code Changes Summary

### Package References
| File | Change | Status |
|---|---|---|
| Bookstore.Data.csproj | Added Npgsql.EntityFrameworkCore.PostgreSQL v8.0.8 | ✅ Complete |
| Bookstore.Web.csproj | Added Npgsql.EntityFrameworkCore.PostgreSQL v8.0.8 | ✅ Complete |
| Both .csproj files | Removed Microsoft.Data.SqlClient / System.Data.SqlClient | ✅ Complete |

### Connection String Configuration
| File | Change | Status |
|---|---|---|
| ServicesSetup.cs | UseNpgsql() for EF Core configuration | ✅ Complete |
| ServicesSetup.cs | NpgsqlConnectionStringBuilder with Host, Port, Database, Username, Password | ✅ Complete |
| appsettings.json | No SQL Server-specific parameters | ✅ Complete |

### Database Access Code
| File | Change | Status |
|---|---|---|
| ApplicationDbContext.cs | Npgsql.EnableLegacyTimestampBehavior switch | ✅ Complete |
| ApplicationDbContext.cs | All entities mapped to bobsbookstore_dbo schema with lowercase column names | ✅ Complete |
| AuthorsController.cs | using Npgsql; import, NpgsqlParameter usage | ✅ Complete |
| ProductsController.cs | using Npgsql; import, NpgsqlParameter usage | ✅ Complete |

### Imports Updated
| Original | Replacement | Files |
|---|---|---|
| using Microsoft.Data.SqlClient | using Npgsql | AuthorsController.cs, ProductsController.cs |
| SqlConnection | NpgsqlConnection | ServicesSetup.cs (via NpgsqlConnectionStringBuilder) |
| SqlParameter | NpgsqlParameter | AuthorsController.cs |

---

## DMS MCP Tool Usage Summary

All 5 SQL statements were submitted to the DMS MCP tool (dms-mcp___statement_conversion_tool) on 3 separate occasions. All attempts consistently failed with the error: "Metadata model creation failed: No objects were found according to the specified selection rules."

**DMS Configuration Used**:
- Migration Project ARN: arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U
- Database Name: BobsBookstore
- Schema Name: dbo
- Server Name: 172.31.82.226
- Region: us-east-1

Detailed DMS attempt timestamps are documented in `dms_conversion_summary.md`.

---

## SQL Equivalency Validation Summary

All 5 statement pairs were validated using the sql-equivalency___validate_sql_equivalence tool. All returned ERROR status with error "'uniqueID'" consistently. No agent judgment was used for equivalency determination.

Full results are documented in `sql_equivalency_validation_report.json`.

---

## Statements Requiring Manual Review

All 5 statements require manual review due to:
1. DMS conversion failure → manual conversion was applied
2. SQL Equivalency tool returned ERROR for all pairs

The manual conversions follow standard PostgreSQL conventions and should be functionally equivalent, but automated validation was unable to confirm this.

---

## Migration Artifacts

| Artifact | Path | Status |
|---|---|---|
| Extracted SQL Statements | `extracted_statements.sql` | ✅ Complete (5 statements) |
| Converted SQL Statements | `converted_statements.sql` | ✅ Complete (5 statements) |
| SQL Equivalency Report | `sql_equivalency_validation_report.json` | ✅ Complete (5 entries) |
| DMS Conversion Summary | `dms_conversion_summary.md` | ✅ Complete |
| Final Migration Report | `final_migration_report.md` | ✅ This file |

---

## Build Status

The application compiles successfully after all migration changes:
- **Build Result**: Success
- **Errors**: 0
- **Warnings**: 184 (all pre-existing NU/CS warnings unrelated to migration)
