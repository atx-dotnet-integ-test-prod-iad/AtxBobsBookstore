# BobsBookstore SQL Server to PostgreSQL Migration Report

## Executive Summary
This report documents the migration of SQL statements in the BobsBookstore .NET ADO application from Microsoft SQL Server syntax to PostgreSQL syntax.

## Migration Statistics

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Statements successfully converted by DMS MCP tool | 0 |
| Statements requiring manual intervention (DMS failure) | 5 |
| Statements validated as equivalent (SQL Equivalency tool) | 0 |
| Statements validated as non-equivalent (SQL Equivalency tool) | 0 |
| Statements with equivalency validation errors (SQL Equivalency tool) | 5 |

## DMS Tool Status
**Status: FAILED for all 5 statements**

All statements were passed through the DMS MCP tool (dms-mcp___statement_conversion_tool) as required. All failed with the same error:
```
Metadata model creation failed: No objects were found according to the specified selection rules. 
Please review your selection rules and try again.
```

Migration project ARN: `arn:aws:dms:us-east-1:789616364195:migration-project:73N4TGCKEFESJJWR43O334CC7U`

Per the transformation definition, manual conversion was performed with lowercase schema object naming for PostgreSQL compatibility (conversion method: `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`).

## SQL Equivalency Tool Status
**Status: ERROR for all 5 statements**

All statement pairs were validated through the SQL Equivalency MCP tool (sql-equivalency___validate_sql_equivalence). All returned ERROR with `'uniqueID'`, indicating a tool-level service issue unrelated to the specific SQL statements being validated.

Per the transformation definition, all equivalency statuses are marked as `ERROR` since the tool returned an error. No agent judgment was used to determine equivalency.

## Statement Conversion Details

### Statement 1: EditUsingStoredProcedure
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `EditUsingStoredProcedure`
- **Original (MS SQL)**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool service error)
- **Notes**: T-SQL DECLARE/EXEC stored procedure call converted to PostgreSQL SELECT function call with lowercase naming

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `FindAllAuthorsEmbeddedSql`
- **Original (MS SQL)**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.author
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.author
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool service error)
- **Notes**: Already PostgreSQL-compatible syntax with lowercase schema. No changes needed.

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `DeleteAuthorEmbeddedSql`
- **Original (MS SQL)**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool service error)
- **Notes**: T-SQL DECLARE/EXEC stored procedure call converted to PostgreSQL SELECT function call with lowercase naming

### Statement 4: SelectAuthorsByHireYear
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `SelectAuthorsByHireYear`
- **Original (MS SQL)**:
  ```sql
  SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_DATE, BirthDate))::int AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_DATE, birthdate))::int AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool service error)
- **Notes**: Column names and aliases lowercased for PostgreSQL compatibility. Functions already PostgreSQL-compatible.

### Statement 5: FindAllProducts
- **Source File**: `app/Bookstore.Web/Controllers/ProductsController.cs`
- **Method**: `FindAllProducts`
- **Original (MS SQL)**:
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool service error)
- **Notes**: T-SQL EXEC stored procedure call converted to PostgreSQL SELECT function call with lowercase naming

## Static Code and Configuration Status

### Package References
- **Status**: Already migrated
- `Npgsql.EntityFrameworkCore.PostgreSQL` (version 8.0.0) is already referenced in `Bookstore.Data.csproj`
- No `Microsoft.Data.SqlClient` or `System.Data.SqlClient` references found

### Database Access Classes
- **Status**: Already migrated
- `NpgsqlParameter` is used throughout controllers (AuthorsController.cs, ProductsController.cs)
- `NpgsqlConnectionStringBuilder` is used in `ServicesSetup.cs`
- `UseNpgsql()` is configured for EF Core in `ServicesSetup.cs`
- No SQL Server-specific classes (`SqlConnection`, `SqlCommand`, etc.) found

### Connection Strings
- **Status**: Already migrated
- Connection strings use PostgreSQL format with `NpgsqlConnectionStringBuilder`
- Host, Database, Username, Password parameters configured for PostgreSQL

## Build Status
- **Result**: Build succeeded with 0 errors
- **Warnings**: 158 pre-existing warnings (primarily NuGet package vulnerability warnings for Magick.NET-Q8-AnyCPU)

## Statements Requiring Manual Review
All 5 statements require manual review due to:
1. DMS tool failure - manual conversion was applied; correctness should be verified against actual PostgreSQL database
2. SQL Equivalency tool error - equivalency could not be validated programmatically

## Migration Artifacts
1. `extracted_statements.sql` - Complete catalog of all 5 original MS SQL statements
2. `converted_statements.sql` - Complete catalog of all 5 converted PostgreSQL statements
3. `sql_equivalency_validation_report.json` - Comprehensive equivalency validation report with all 5 statement pairs
4. `migration_report.md` - This report
