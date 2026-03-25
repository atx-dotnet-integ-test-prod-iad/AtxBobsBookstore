# Migration Report: MS SQL Server to PostgreSQL

## Date: 2026-03-25
## Application: BobsBookstore .NET Web Application

---

## Executive Summary

This report documents the migration of the BobsBookstore .NET ADO application from Microsoft SQL Server to PostgreSQL. The migration involved converting 5 SQL statements embedded in the C# codebase, updating package references, and verifying the elimination of all SQL Server-specific code patterns.

---

## SQL Statement Conversion Summary

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Successfully converted by DMS MCP tool | 0 |
| Requiring manual intervention (DMS failure) | 5 |
| Validated as EQUIVALENT by SQL Equivalency tool | 0 |
| Validated as NOT_EQUIVALENT | 0 |
| With equivalency validation ERROR | 5 |

### DMS Tool Status
All 5 statements were submitted to the DMS MCP tool (`dms-mcp___statement_conversion_tool`). All 5 failed with the error:
> "Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again."

Manual conversion was applied using lowercase schema mapping rules per the transformation definition, with conversion method documented as `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`.

### SQL Equivalency Tool Status
All 5 statement pairs were submitted to the SQL Equivalency tool (`sql-equivalency___validate_sql_equivalence`). All 5 returned ERROR with `'uniqueID'` error, indicating a systemic tool issue rather than conversion quality problems.

---

## Detailed SQL Statement Conversion

### Statement 1: EditUsingStoredProcedure
- **Source**: `AuthorsController.cs:163`
- **Original (MS SQL)**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source**: `AuthorsController.cs:187`
- **Original (MS SQL)**:
  ```sql
  SELECT * FROM "bobsbookstore_dbo"."author"
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM "bobsbookstore_dbo"."author"
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)
- **Note**: Statement was already PostgreSQL-compatible with lowercase schema/table names

### Statement 3: DeleteAuthorEmbeddedSql
- **Source**: `AuthorsController.cs:206`
- **Original (MS SQL)**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

### Statement 4: SelectAuthorsByHireYear
- **Source**: `AuthorsController.cs:228`
- **Original (MS SQL)**:
  ```sql
  SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_DATE, BirthDate))::int AS Age FROM "bobsbookstore_dbo"."author" WHERE DATE_PART('year', HireDate) = @HireDate;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_DATE, birthdate))::int AS age FROM "bobsbookstore_dbo"."author" WHERE DATE_PART('year', hiredate) = @HireDate;
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)
- **Note**: PostgreSQL functions (TO_CHAR, DATE_PART, AGE) were already present; only column names/aliases were lowercased

### Statement 5: FindAllProducts
- **Source**: `ProductsController.cs:34`
- **Original (MS SQL)**:
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned 'uniqueID' error)

---

## Package Changes

| Action | Package | Version |
|--------|---------|---------|
| **Removed** | Microsoft.EntityFrameworkCore.Sqlite | 5.0.7 |
| Already Present | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 |

---

## Already Migrated Components (Pre-existing)

The following components were already migrated to PostgreSQL before this transformation:

1. **Npgsql Package References**: `Npgsql.EntityFrameworkCore.PostgreSQL` v8.0.0 was already in Bookstore.Web.csproj
2. **Using Statements**: `using Npgsql;` was already present in both controller files
3. **NpgsqlParameter Usage**: All parameter bindings already used `NpgsqlParameter` instead of `SqlParameter`
4. **Connection Strings**: Already configured with `NpgsqlConnectionStringBuilder` using Host, Port, Database, Username, Password parameters
5. **EF Core DbContext**: Already configured with `option.UseNpgsql(connString)` in ServicesSetup.cs
6. **Entity Mappings**: All entity column mappings already use lowercase PostgreSQL column names

---

## Code Verification Sweep Results

| Check | Result |
|-------|--------|
| SqlConnection references | ✅ None found |
| SqlCommand references | ✅ None found |
| SqlDataReader references | ✅ None found |
| SqlParameter references (non-Npgsql) | ✅ None found |
| Microsoft.Data.SqlClient imports | ✅ None found |
| System.Data.SqlClient imports | ✅ None found |
| UseSqlServer calls | ✅ None found |
| DECLARE @ syntax in SQL strings | ✅ None found |
| EXEC syntax in SQL strings | ✅ None found |
| [dbo]. schema references | ✅ None found |
| Sqlite package references | ✅ Removed |

---

## Build Status

**Final build: ✅ SUCCESS** (0 errors, warnings only related to Magick.NET-Q8-AnyCPU vulnerability advisories)

---

## Files Modified

1. `app/Bookstore.Web/Controllers/AuthorsController.cs` - 4 SQL statements converted to PostgreSQL, TODO comments removed
2. `app/Bookstore.Web/Controllers/ProductsController.cs` - 1 SQL statement converted to PostgreSQL, TODO comment removed
3. `app/Bookstore.Web/Bookstore.Web.csproj` - Removed Microsoft.EntityFrameworkCore.Sqlite package reference

## Artifacts Generated

1. `extracted_statements.sql` - Catalog of all 5 original SQL statements
2. `converted_statements.sql` - Catalog of all original and converted statement pairs
3. `sql_equivalency_validation_report.json` - Comprehensive equivalency validation report
4. `dms_conversion_issues.md` - Detailed DMS conversion failure documentation
5. `migration_report.md` - This comprehensive migration report
